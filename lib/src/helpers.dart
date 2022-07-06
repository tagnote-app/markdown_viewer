import 'package:flutter/material.dart';

List<Widget> mergeInlineChildren(
  List<Widget> children, {
  required Widget Function(TextSpan span) richTextBuilder,
}) {
  if (children.isEmpty) {
    return children;
  }

  final mergedWidgets = <Widget>[];
  var mergedTexts = <Widget>[];

  // TODO(Zhiguang): Why? Try to remove the Wrap.
  // Enclose all text widgets in a `Wrap` widget.
  void addWithWrap() {
    if (mergedTexts.isEmpty) {
      return;
    }

    mergedWidgets.add(Wrap(children: mergedTexts));
    mergedTexts = <Widget>[];
  }

  for (final child in children) {
    if (child is RichText || child is SelectableText) {
      if (mergedTexts.isEmpty) {
        mergedTexts.add(child);
        continue;
      }
      final previous = mergedTexts.removeLast();

      final previousTextSpan = previous is SelectableText
          ? previous.textSpan!
          : (previous as RichText).text as TextSpan;
      final children = previousTextSpan.children != null
          ? List<TextSpan>.from(previousTextSpan.children!)
          : [previousTextSpan];

      if (child is RichText) {
        children.add(child.text as TextSpan);
      } else if (child is SelectableText && child.textSpan != null) {
        children.add(child.textSpan!);
      }

      final mergedSpan = _mergeSimilarTextSpans(children);
      mergedTexts.add(richTextBuilder(mergedSpan));
    } else {
      addWithWrap();
      mergedWidgets.add(child);
    }
  }

  addWithWrap();

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

String trimText(String text) {
  return text.replaceAll('\n', ' ');
}

bool isBlockElement(String type) => [
      'paragraph',
      'atxHeading',
      'setextHeading',
      'htmlBlock',
      'bulletList',
      'orderedList',
      'listItem',
      'thematicBreak',
      'blockquote',
      'fencedBlockquote',
      'indentedCodeBlock',
      'fencedCodeBlock',
      'table',
      'tableRow',
      'tableHead',
      'tableBody',
    ].contains(type);

// == INLINE TYPES ==
// link
// image
// autolink
// hardLineBreak
// emphasis
// strongEmphasis
// emoji
// codeSpan
// backslashEscape
// extendedAutolink
// rawHtml
// tableBodyCell
// tableHeadCell

// linkReferenceDefinition
// linkReferenceDefinitionLabel
// linkReferenceDefinitionDestination
// linkReferenceDefinitionTitle

bool isLinkElement(String type) =>
    ['link', 'autolink', 'extendedAutolink'].contains(type);

bool isListElement(String type) => ['bulletList', 'orderedList'].contains(type);

bool isCodeBlockElement(String type) =>
    ['indentedCodeBlock', 'fencedCodeBlock'].contains(type);
