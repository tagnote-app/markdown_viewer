import 'package:flutter/material.dart';

import 'builder.dart';

class ParagraphBuilder extends MarkdownElementBuilder {
  ParagraphBuilder({
    super.textStyle,
    this.padding,
  });

  final EdgeInsets? padding;

  @override
  final matchTypes = ['paragraph'];

  @override
  EdgeInsets? blockPadding(element) {
    if (padding == null) {
      return null;
    }

    final position = element.element.position;
    final isLast = position.index + 1 == position.total;
    final isFirst = position.index == 0;

    if (!isLast && !isFirst) {
      return padding;
    }

    if (isFirst) {
      return padding!.copyWith(
        top: 0,
        bottom: padding!.bottom,
        left: padding!.left,
        right: padding!.right,
      );
    }

    if (isLast) {
      return padding!.copyWith(
        top: padding!.top,
        bottom: 0,
        left: padding!.left,
        right: padding!.right,
      );
    }

    return padding;
  }
}
