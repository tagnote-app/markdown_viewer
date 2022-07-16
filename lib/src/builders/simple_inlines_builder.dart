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
    TextStyle? subscript,
    TextStyle? superscript,
    TextStyle? link,
    TextStyle? kbd,
    TextStyle? inlineCode,
    MarkdownTapLinkCallback? onTapLink,
  })  : _onTapLink = onTapLink,
        super(textStyleMap: {
          'emphasis': emphasis,
          'strongEmphasis': strongEmphasis,
          'inlineCode': inlineCode,
          'highlight': highlight,
          'strikethrough': strikethrough,
          'subscript': subscript,
          'superscript': superscript,
          'link': link,
          'kbd': kbd,
        });
  final MarkdownTapLinkCallback? _onTapLink;

  @override
  bool isBlock(element) => false;

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
  TextSpan? createText(element, parentStyle) {
    if (element.type != 'hardLineBreak') {
      return null;
    }

    return TextSpan(text: '\n', style: parentStyle);
  }

  @override
  final matchTypes = [
    'emphasis',
    'strongEmphasis',
    'link',
    'hardLineBreak',
    'inlineCode',
    'highlight',
    'strikethrough',
    'emoji',
    'superscript',
    'subscript',
    'kbd',
  ];
}
