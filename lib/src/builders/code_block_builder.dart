import 'package:flutter/material.dart';

import '../definition.dart';
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
  TextSpan buildText(text, parent) {
    return highlightBuilder == null
        ? TextSpan(
            text: text.trimRight(),
            style: parent.style,
          )
        : highlightBuilder!(text, parent.attributes['language'],
            parent.attributes['infoString']);
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
