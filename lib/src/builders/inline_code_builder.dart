import 'package:flutter/material.dart';
import 'builder.dart';

class InlineCodeBuilder extends MarkdownElementBuilder {
  InlineCodeBuilder({
    TextStyle? textStyle,
  }) : super(
          textStyle: const TextStyle(
            color: Color(0xff8b1c1c),
            fontFamily: 'monospace',
            backgroundColor: Color(0x10000000),
          ).merge(textStyle),
        );

  @override
  final matchTypes = ['inlineCode'];

  double? _lineHeight;

  @override
  TextStyle? buildTextStyle(element, defaultStyle) {
    final style = super.buildTextStyle(element, defaultStyle);
    _lineHeight = style?.height;

    return style?.copyWith(height: 1);
  }

  @override
  Widget? buildWidget(element, parent) {
    final richText = element.children.single as RichText;

    // The purpose of this is to make the RichText has the same line height as
    // it should be while the line height of TextSpan has been changed to 1.
    return renderer.createRichText(
      richText.text as TextSpan,
      strutStyle: StrutStyle(height: _lineHeight, forceStrutHeight: true),
    );
  }
}
