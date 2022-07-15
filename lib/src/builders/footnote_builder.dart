import 'package:flutter/material.dart';

import 'builder.dart';

class FootnoteBuilder extends MarkdownElementBuilder {
  FootnoteBuilder({
    TextStyle? footnote,
    TextStyle? footnoteReference,
  }) : super(textStyleMap: {
          'footnote': footnote,
          'footnoteReference': footnoteReference,
        });

  @override
  final matchTypes = [
    'footnote',
    'footnoteReference',
  ];

  @override
  TextSpan? createText(element, parentStyle) {
    if (element.type == 'footnote') {
      return TextSpan(
        text: element.attributes['number'],
        style: element.style,
      );
    }
    return null;
  }

  @override
  void after(renderer, element) {
    if (element.type == 'footnote') {
      renderer.writeInline(element.children);
    } else if (element.type == 'footnoteReference') {
      renderer.writeBlock(element.children.single);
    }
  }
}
