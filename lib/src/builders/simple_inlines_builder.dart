import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../definition.dart';
import 'builder.dart';

class SimpleInlinesBuilder extends MarkdownElementBuilder {
  SimpleInlinesBuilder({
    TextStyle? emphasis,
    TextStyle? strongEmphasis,
    TextStyle? highlight,
    TextStyle? strikethrough,
    TextStyle? link,
    TextStyle? inlineCode,
    MarkdownTapLinkCallback? onTapLink,
  })  : _onTapLink = onTapLink,
        super(textStyleMap: {
          'emphasis': emphasis,
          'strongEmphasis': strongEmphasis,
          'inlineCode': inlineCode,
          'highlight': highlight,
          'strikethrough': strikethrough,
          'link': link,
        });
  final MarkdownTapLinkCallback? _onTapLink;

  @override
  GestureRecognizer? gestureRecognizer(type, attributes) {
    if (type != 'link' || _onTapLink == null) {
      return null;
    }

    return TapGestureRecognizer()
      ..onTap = () {
        _onTapLink!(
          attributes['destination'],
          attributes['title'],
        );
      };
  }

  @override
  TextSpan? createText(String type, TextStyle? style) {
    if (type != 'hardLineBreak') {
      return null;
    }

    return TextSpan(text: '\n', style: style);
  }

  @override
  final matchTypes = [
    'emphasis',
    'strongEmphasis',
    'link',
    'image',
    'hardLineBreak',
    'inlineCode',
    'highlight',
    'strikethrough',
    'emoji',
  ];

  @override
  void after(renderer, element) {
    renderer.writeInline(element.children);
  }
}
