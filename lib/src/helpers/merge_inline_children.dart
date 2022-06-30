import 'package:flutter/material.dart';

// The code in this file is from
// https://github.com/flutter/packages/blob/main/packages/flutter_markdown/lib/src/builder.dart#L666

/// Merges adjacent [TextSpan] children
List<Widget> mergeInlineChildren(
  List<Widget> children, {
  required Widget Function(TextSpan? span, {TextAlign? textAlign})
      richTextBuilder,
  TextAlign? textAlign,
}) {
  final List<Widget> mergedTexts = <Widget>[];
  for (final Widget child in children) {
    if (mergedTexts.isNotEmpty &&
        mergedTexts.last is RichText &&
        child is RichText) {
      final RichText previous = mergedTexts.removeLast() as RichText;
      final TextSpan previousTextSpan = previous.text as TextSpan;
      final List<TextSpan> children = previousTextSpan.children != null
          ? previousTextSpan.children!
              .map((InlineSpan span) => span is! TextSpan
                  ? TextSpan(children: <InlineSpan>[span])
                  : span)
              .toList()
          : <TextSpan>[previousTextSpan];
      children.add(child.text as TextSpan);
      final TextSpan? mergedSpan = _mergeSimilarTextSpans(children);
      mergedTexts.add(richTextBuilder(
        mergedSpan,
        textAlign: textAlign,
      ));
    } else if (mergedTexts.isNotEmpty &&
        mergedTexts.last is SelectableText &&
        child is SelectableText) {
      final SelectableText previous =
          mergedTexts.removeLast() as SelectableText;
      final TextSpan previousTextSpan = previous.textSpan!;
      final List<TextSpan> children = previousTextSpan.children != null
          ? List<TextSpan>.from(previousTextSpan.children!)
          : <TextSpan>[previousTextSpan];
      if (child.textSpan != null) {
        children.add(child.textSpan!);
      }
      final TextSpan? mergedSpan = _mergeSimilarTextSpans(children);
      mergedTexts.add(
        richTextBuilder(
          mergedSpan,
          textAlign: textAlign,
        ),
      );
    } else {
      mergedTexts.add(child);
    }
  }
  return mergedTexts;
}

/// Combine text spans with equivalent properties into a single span.
TextSpan? _mergeSimilarTextSpans(List<TextSpan>? textSpans) {
  if (textSpans == null || textSpans.length < 2) {
    return TextSpan(children: textSpans);
  }

  final List<TextSpan> mergedSpans = <TextSpan>[textSpans.first];

  for (int index = 1; index < textSpans.length; index++) {
    final TextSpan nextChild = textSpans[index];
    if (nextChild.recognizer == mergedSpans.last.recognizer &&
        nextChild.semanticsLabel == mergedSpans.last.semanticsLabel &&
        nextChild.style == mergedSpans.last.style) {
      final TextSpan previous = mergedSpans.removeLast();
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
