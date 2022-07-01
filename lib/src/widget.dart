import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'builder.dart';
import 'style.dart';

class MarkdownViewer extends StatefulWidget {
  const MarkdownViewer(
    this.data, {
    this.styleSheet,
    this.onTapLink,
    Key? key,
  }) : super(key: key);

  final String data;
  final MarkdownStyle? styleSheet;
  final MarkdownTapLinkCallback? onTapLink;

  @override
  State<MarkdownViewer> createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    _parseMarkdown();

    if (_children.length == 1) {
      return _children.single;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _children,
    );
  }

  void _parseMarkdown() {
    final md.Document document = md.Document();
    final astNodes = document.parseLines(widget.data);
    final styleSheet =
        widget.styleSheet ?? MarkdownStyle.fromTheme(Theme.of(context));

    final builder = MarkdownBuilder(
      styleSheet: styleSheet,
      onTapLink: widget.onTapLink,
    );
    _children = builder.build(astNodes);
  }
}
