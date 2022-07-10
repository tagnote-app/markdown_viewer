import 'package:flutter/material.dart';

import 'builder.dart';

class SimpleBlocksBuilder extends MarkdownElementBuilder {
  SimpleBlocksBuilder({
    TextStyle? paragraph,
    TextStyle? blockquote,
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
  final Color? dividerColor;
  final double? dividerHeight;
  final double? dividerThickness;

  @override
  bool replaceLineEndings(type) => type != 'blockquote';

  @override
  final matchTypes = ['paragraph', 'blockquote', 'thematicBreak'];

  @override
  void after(renderer, element) {
    final type = element.type;

    Widget blockChild;
    if (type == 'thematicBreak') {
      blockChild = Divider(
        color: dividerColor,
        height: dividerHeight,
        thickness: dividerThickness,
      );
    } else {
      blockChild = renderer.convertToBlock(element.children);
      if (type == 'blockquote') {
        blockChild = Container(
          width: double.infinity,
          decoration: blockquoteDecoration,
          child: Padding(
            padding: blockquotePadding,
            child: blockChild,
          ),
        );
      }
    }

    renderer.writeBlock(blockChild);
  }
}
