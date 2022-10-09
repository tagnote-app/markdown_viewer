import 'package:flutter/material.dart';

import '../helpers/parse_block_padding.dart';
import 'builder.dart';

class BlockquoteBuilder extends MarkdownElementBuilder {
  BlockquoteBuilder({
    TextStyle? textStyle,
    this.padding,
    this.contentPadding,
    this.decoration,
  }) : super(
          textStyle: const TextStyle(
            color: Color(0xff666666),
          ).merge(textStyle),
        );

  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final BoxDecoration? decoration;

  @override
  final matchTypes = ['blockquote'];

  @override
  Widget? buildWidget(element, parent) {
    final widget = Container(
      width: double.infinity,
      decoration: decoration ??
          const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Color(0xffcccccc),
                width: 5,
              ),
            ),
          ),
      padding: contentPadding ?? const EdgeInsets.only(left: 20),
      child: super.buildWidget(element, parent),
    );

    final parsedPadding = parseBlockPadding(padding, element.element.position);

    if (parsedPadding == null) {
      return widget;
    }

    return Padding(padding: parsedPadding, child: widget);
  }
}
