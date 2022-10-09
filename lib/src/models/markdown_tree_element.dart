import 'package:flutter/widgets.dart';

/// A class for for the tree element produced by [MarkdownRenderer].
abstract class MarkdownTreeElement {
  MarkdownTreeElement({
    required this.type,
    required this.attributes,
    required this.isBlock,
    this.style,
  });

  final String type;
  final bool isBlock;
  final TextStyle? style;
  final Map<String, String> attributes;
  final List<Widget> children = <Widget>[];
}

abstract class MarkdownImageInfo {
  MarkdownImageInfo({
    this.title,
    this.description,
    this.width,
    this.height,
  });

  final String? title;
  final String? description;
  final double? width;
  final double? height;
}
