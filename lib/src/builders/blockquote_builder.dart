import 'package:flutter/material.dart';

import 'builder.dart';

class BlockquoteBuilder extends MarkdownElementBuilder {
  BlockquoteBuilder({
    super.textStyle,
    this.padding,
    this.decoration,
  });

  final EdgeInsets? padding;
  final BoxDecoration? decoration;

  @override
  final matchTypes = ['blockquote'];

  @override
  Widget? buildWidget(element) {
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
        child: super.buildWidget(element),
      ),
    );
  }
}
