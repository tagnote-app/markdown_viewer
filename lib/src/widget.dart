import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'builder.dart';
import 'style.dart';

class MarkdownViewer extends StatefulWidget {
  const MarkdownViewer(
    this.data, {
    this.styleSheet,
    this.onTapLink,
    this.listItemMarkerBuilder,
    this.checkboxBuilder,
    this.enableTaskList = false,
    Key? key,
  }) : super(key: key);

  final String data;
  final bool enableTaskList;
  final MarkdownStyle? styleSheet;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownListItemMarkerBuilder? listItemMarkerBuilder;
  final MarkdownCheckboxBuilder? checkboxBuilder;

  @override
  State<MarkdownViewer> createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    _parseMarkdown();

    Widget widget;
    if (_children.length > 1) {
      widget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children,
      );
    } else if (_children.length == 1) {
      widget = _children.single;
    } else {
      widget = const SizedBox.shrink();
    }

    return widget;
  }

  void _parseMarkdown() {
    final md.Document document =
        md.Document(enableTaskList: widget.enableTaskList);
    final theme = Theme.of(context);
    final astNodes = document.parseLines(widget.data);

    // TODO(Zhiguang): merge custom stylesheet with the default.
    final styleSheet = widget.styleSheet ??
        MarkdownStyle.fromTheme(
          theme,
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 5.0, color: theme.dividerColor),
            ),
          ),
        );

    final builder = MarkdownBuilder(
      styleSheet: styleSheet,
      onTapLink: widget.onTapLink,
      listItemMarkerBuilder: widget.listItemMarkerBuilder,
      checkboxBuilder: widget.checkboxBuilder,
    );
    _children = builder.build(astNodes);
  }
}
