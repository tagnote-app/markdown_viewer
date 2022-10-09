import 'package:flutter/material.dart';

import 'builder.dart';

class BlockquoteBuilder extends MarkdownElementBuilder {
  BlockquoteBuilder({
    TextStyle? textStyle,
    this.padding,
    this.decoration,
  }) : super(
          textStyle: const TextStyle(
            color: Color(0xff666666),
          ).merge(textStyle),
        );

  final EdgeInsets? padding;
  final BoxDecoration? decoration;

  @override
  final matchTypes = ['blockquote'];

  @override
  Widget? buildWidget(element, parent) {
    return Container(
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
      child: Padding(
        padding: padding ?? const EdgeInsets.only(left: 20),
        child: super.buildWidget(element, parent),
      ),
    );
  }
}
