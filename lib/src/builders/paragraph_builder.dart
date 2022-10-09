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
  EdgeInsets? blockPadding(element) => padding;
}
