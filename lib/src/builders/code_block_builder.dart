import 'package:flutter/material.dart';

import '../definition.dart';
import '../helpers.dart';
import 'builder.dart';

class CodeBlockBuilder extends MarkdownElementBuilder {
  CodeBlockBuilder({
    TextStyle? textStyle,
    this.codeblockPadding,
    this.codeblockDecoration,
    this.highlightBuilder,
  }) : super(textStyle: textStyle);

  final EdgeInsets? codeblockPadding;
  final BoxDecoration? codeblockDecoration;
  final MarkdownHighlightBuilder? highlightBuilder;

  @override
  final matchTypes = ['codeBlock'];

  @override
  bool replaceLineEndings(String type) => false;

  @override
  TextAlign textAlign(parent) => TextAlign.start;

  @override
  TextSpan buildText(text, parent, selectable) {
    final textContent = text.trimRight();

    if (highlightBuilder == null) {
      return TextSpan(
        text: textContent,
        style: parent.style,
        mouseCursor: mouseCursor(selectable),
      );
    }

    final spans = highlightBuilder!(
      textContent,
      parent.attributes['language'],
      parent.attributes['infoString'],
    );

    if (spans.isEmpty) {
      return const TextSpan(text: '');
    }

    return TextSpan(
      children: spans,
      style: parent.style,
      mouseCursor: mouseCursor(selectable),
    );
  }

  @override
  Widget buildWidget(element) {
    final child = element.children.isNotEmpty
        ? element.children.single
        : const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: codeblockDecoration,
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: codeblockPadding,
          child: child,
        ),
      ),
    );
  }
}
