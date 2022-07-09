import 'package:flutter/material.dart';

typedef MarkdownTapLinkCallback = void Function(String? href, String? title);

typedef MarkdownListItemMarkerBuilder = Widget Function(
    ListType style, String? number);

typedef MarkdownCheckboxBuilder = Widget Function(bool checked);

typedef MarkdownHighlightBuilder = TextSpan Function(
    String text, String? language, String? infoString);

enum TableRowDecorationAlternating { odd, even }

enum ListType { ordered, unordered }
