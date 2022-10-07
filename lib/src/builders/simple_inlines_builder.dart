import 'dart:ui';

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
          'emphasis': const TextStyle(
            fontStyle: FontStyle.italic,
          ).merge(emphasis),
          'strongEmphasis': const TextStyle(
            fontWeight: FontWeight.w700,
          ).merge(strongEmphasis),
          'inlineCode': const TextStyle(
            fontFamily: 'monospace',
          ).merge(inlineCode),
          'highlight': const TextStyle(
            backgroundColor: Color(0xffffee00),
          ).merge(highlight),
          'strikethrough': const TextStyle(
            color: Color(0xffff6666),
            decoration: TextDecoration.lineThrough,
          ).merge(strikethrough),
          'subscript': const TextStyle(
            fontFeatures: [FontFeature.subscripts()],
          ).merge(subscript),
          'superscript': const TextStyle(
            fontFeatures: [FontFeature.superscripts()],
          ).merge(superscript),
          'link': const TextStyle(color: Color(0xff2196f3)).merge(link),
          'kbd': kbd,
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
