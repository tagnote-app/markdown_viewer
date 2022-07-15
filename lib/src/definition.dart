import 'package:flutter/material.dart';

/// Enumeration of the ways to alternate the table row background.
enum MarkdownAlternating { odd, even }

/// Enumeration of list types.
enum MarkdownListType { ordered, unordered }

/// Signature for callbacks used by [MarkdownWidget] when the user taps a link.
typedef MarkdownTapLinkCallback = void Function(
  String? href,
  String? title,
);

/// Signature for custom list item marker widget.
typedef MarkdownListItemMarkerBuilder = Widget Function(
  MarkdownListType style,
  String? number,
);

/// Signature for custom checkbox widget.
typedef MarkdownCheckboxBuilder = Widget Function(bool checked);

/// Signature for custom image widget.
typedef MarkdownImageBuilder = Widget Function(Uri uri, MarkdownImageInfo info);

/// Syntax highlights [text] for codeBlock element.
typedef MarkdownHighlightBuilder = TextSpan Function(
  String text,
  String? language,
  String? infoString,
);

/// A class for for the tree element produced by [MarkdownRenderer].
abstract class MarkdownTreeElement {
  MarkdownTreeElement({
    required this.type,
    required this.attributes,
    this.style,
  });

  final String type;
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
