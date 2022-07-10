import 'package:flutter/material.dart';

import 'builder.dart';

class SimpleBlocksBuilder extends MarkdownElementBuilder {
  SimpleBlocksBuilder({
    TextStyle? blockquote,
    TextStyle? paragraph,
    this.dividerColor,
    this.dividerHeight,
    this.dividerThickness,
    required this.blockquoteDecoration,
    required this.blockquotePadding,
  }) : super(textStyleMap: {
          'blockquote': blockquote,
          'paragraph': paragraph,
        });

  final Decoration blockquoteDecoration;
  final EdgeInsets blockquotePadding;
  final double? dividerHeight;
  final double? dividerThickness;
  final Color? dividerColor;

  @override
  bool replaceLineEndings(type) => type != 'blockquote';

  @override
  final matchTypes = ['blockquote', 'paragraph', 'thematicBreak'];

  @override
  void after(renderer, element) {
    final type = element.type;

    Widget blockChild;
    if (type == 'thematicBreak') {
      blockChild = Divider(
        thickness: dividerThickness,
        color: dividerColor,
        height: dividerHeight,
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

    renderer.write(blockChild);
  }
}
