import 'package:flutter/material.dart';

import 'builder.dart';

class SimpleBlocksBuilder extends MarkdownElementBuilder {
  SimpleBlocksBuilder({
    TextStyle? paragraph,
    this.paragraphPadding,
    this.dividerColor,
    this.dividerHeight,
    this.dividerThickness,
  }) : super(textStyleMap: {
          'paragraph': paragraph,
        });

  final EdgeInsets? paragraphPadding;
  final Color? dividerColor;
  final double? dividerHeight;
  final double? dividerThickness;

  @override
  final matchTypes = ['paragraph', 'thematicBreak'];

  @override
  EdgeInsets? blockPadding(element) {
    return element.type == 'paragraph' ? paragraphPadding : null;
  }

  @override
  Widget? buildWidget(element) {
    final type = element.type;

    if (type == 'thematicBreak') {
      return Divider(
        color: dividerColor,
        height: dividerHeight,
        thickness: dividerThickness,
      );
    }

    return super.buildWidget(element);
  }
}
