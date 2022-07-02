import 'package:flutter/material.dart';

// The code in this file is from
// https://github.com/flutter/packages/blob/main/packages/flutter_markdown/lib/src/builder.dart#L666

/// Merges adjacent [TextSpan] children
// TODO(Zhiguang): Simplify this function, it is impossible that a inline
// widget is adjacent to a block widget. So only need to check the first child
// to determine if need to iterate the children.
List<Widget> mergeInlineChildren(
  List<Widget> children, {
  required Widget Function(TextSpan? span, {TextAlign? textAlign})
      richTextBuilder,
  TextAlign? textAlign,
}) {
  final mergedTexts = <Widget>[];
  for (final Widget child in children) {
    if (mergedTexts.isNotEmpty && mergedTexts.last is Wrap) {
      final wrap = mergedTexts.last as Wrap;
      final mergeGroup = wrap.children;

      if (mergeGroup.last is RichText && child is RichText) {
        final previous = mergeGroup.removeLast() as RichText;
        final previousTextSpan = previous.text as TextSpan;
        final children = previousTextSpan.children != null
            ? previousTextSpan.children!
                .map((InlineSpan span) => span is! TextSpan
                    ? TextSpan(children: <InlineSpan>[span])
                    : span)
                .toList()
            : <TextSpan>[previousTextSpan];
        children.add(child.text as TextSpan);
        final mergedSpan = _mergeSimilarTextSpans(children);
        mergeGroup.add(richTextBuilder(
          mergedSpan,
          textAlign: textAlign,
        ));
      } else if (mergeGroup.last is SelectableText && child is SelectableText) {
        final previous = mergeGroup.removeLast() as SelectableText;
        final previousTextSpan = previous.textSpan!;
        final children = previousTextSpan.children != null
            ? List<TextSpan>.from(previousTextSpan.children!)
            : <TextSpan>[previousTextSpan];
        if (child.textSpan != null) {
          children.add(child.textSpan!);
        }
        final mergedSpan = _mergeSimilarTextSpans(children);
        mergeGroup.add(
          richTextBuilder(
            mergedSpan,
            textAlign: textAlign,
          ),
        );
      }
    } else {
      if (child is RichText || child is SelectableText) {
        // Enclose all inline widgets in a `Wrap` widget.
        mergedTexts.add(Wrap(
          children: [child],
        ));
      } else {
        mergedTexts.add(child);
      }
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
