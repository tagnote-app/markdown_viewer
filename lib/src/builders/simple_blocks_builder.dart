import 'package:flutter/material.dart';

import 'builder.dart';

class SimpleBlocksBuilder extends MarkdownElementBuilder {
  SimpleBlocksBuilder({
    TextStyle? paragraph,
    TextStyle? blockquote,
    this.pPadding,
    this.blockquoteDecoration,
    required this.blockquotePadding,
    this.dividerColor,
    this.dividerHeight,
    this.dividerThickness,
  }) : super(textStyleMap: {
          'paragraph': paragraph,
          'blockquote': blockquote,
        });

  final Decoration? blockquoteDecoration;
  final EdgeInsets blockquotePadding;
  final EdgeInsets? pPadding;
  final Color? dividerColor;
  final double? dividerHeight;
  final double? dividerThickness;

  @override
  bool replaceLineEndings(type) => type != 'blockquote';

  @override
  final matchTypes = ['paragraph', 'blockquote', 'thematicBreak'];

  @override
  EdgeInsets? blockPadding(element) {
    return element.type == 'paragraph' ? pPadding : null;
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

    final blockChild = super.buildWidget(element);

    if (type == 'blockquote') {
      return Container(
        width: double.infinity,
        decoration: blockquoteDecoration,
        child: Padding(
          padding: blockquotePadding,
          child: blockChild,
        ),
      );
    }

    return blockChild;
  }
}
