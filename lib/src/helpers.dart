import 'package:flutter/material.dart';

List<Widget> mergeRichText(
  List<Widget> children, {
  required Widget Function(TextSpan span, TextAlign? textAlign) richTextBuilder,
}) {
  if (children.isEmpty) {
    return children;
  }

  final mergedWidgets = <Widget>[];
  var textStack = <Widget>[];

  void writeWidget() {
    if (textStack.isEmpty) {
      return;
    }

    mergedWidgets.addAll(textStack);
    textStack = <Widget>[];
  }

  for (final child in children) {
    if (child is RichText || child is SelectableText) {
      if (textStack.isEmpty) {
        textStack.add(child);
        continue;
      }
      final previous = textStack.removeLast();

      final previousTextSpan = previous is SelectableText
          ? previous.textSpan!
          : (previous as RichText).text as TextSpan;
      final children = previousTextSpan.children != null
          ? List<TextSpan>.from(previousTextSpan.children!)
          : [previousTextSpan];

      TextAlign? textAlign;
      if (child is RichText) {
        children.add(child.text as TextSpan);
        textAlign = child.textAlign;
      } else if (child is SelectableText && child.textSpan != null) {
        children.add(child.textSpan!);
        textAlign = child.textAlign;
      }

      final mergedSpan = _mergeSimilarTextSpans(children);
      textStack.add(richTextBuilder(mergedSpan, textAlign));
    } else {
      writeWidget();
      mergedWidgets.add(child);
    }
  }

  writeWidget();

  return mergedWidgets;
}

/// Combine text spans with equivalent properties into a single span.
TextSpan _mergeSimilarTextSpans(List<TextSpan>? textSpans) {
  if (textSpans == null || textSpans.length < 2) {
    return TextSpan(children: textSpans);
  }

  final mergedSpans = <TextSpan>[textSpans.first];

  for (var index = 1; index < textSpans.length; index++) {
    final nextChild = textSpans[index];
    if (nextChild.recognizer == mergedSpans.last.recognizer &&
        nextChild.semanticsLabel == mergedSpans.last.semanticsLabel &&
        nextChild.style == mergedSpans.last.style) {
      final previous = mergedSpans.removeLast();
      mergedSpans.add(TextSpan(
        text: previous.toPlainText() + nextChild.toPlainText(),
        recognizer: previous.recognizer,
        semanticsLabel: previous.semanticsLabel,
        style: previous.style,
      ));
    } else {
      mergedSpans.add(nextChild);
    }
  }

  // When the mergered spans compress into a single TextSpan return just that
  // TextSpan, otherwise bundle the set of TextSpans under a single parent.
  return mergedSpans.length == 1
      ? mergedSpans.first
      : TextSpan(children: mergedSpans);
}
