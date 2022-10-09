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
  EdgeInsets? blockPadding(element, parent) {
    // When a list is not tight, add padding to list item
    if (padding == null || parent.type == 'listItem') {
      return null;
    }

    final position = element.element.position;
    final isLast = position.index + 1 == position.total;
    final isFirst = position.index == 0;

    if (!isLast && !isFirst) {
      return padding;
    }

    var top = padding!.top;
    var bottom = padding!.bottom;

    if (isFirst && isLast) {
      top = 0;
      bottom = 0;
    } else if (isFirst) {
      top = 0;
    } else if (isLast) {
      bottom = 0;
    }

    return padding!.copyWith(
      top: top,
      bottom: bottom,
      left: padding!.left,
      right: padding!.right,
    );
  }
}
