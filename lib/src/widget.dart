import 'dart:developer';

import 'package:dart_markdown/dart_markdown.dart' as md;
import 'package:flutter/material.dart';

import 'builders/builder.dart';
import 'definition.dart';
import 'extensions.dart';
import 'renderer.dart';
import 'style.dart';

class MarkdownViewer extends StatefulWidget {
  const MarkdownViewer(
    this.data, {
    this.styleSheet,
    this.onTapLink,
    this.listItemMarkerBuilder,
    this.highlightBuilder,
    this.checkboxBuilder,
    this.imageBuilder,
    this.enableTaskList = false,
    this.enableSubscript = false,
    this.enableSuperscript = false,
    this.enableKbd = false,
    this.enableFootnote = false,
    this.enableImageSize = false,
    this.elementBuilders = const [],
    this.syntaxExtensions = const [],
    Key? key,
  }) : super(key: key);

  final String data;
  final bool enableTaskList;
  final bool enableImageSize;
  final bool enableSubscript;
  final bool enableSuperscript;
  final bool enableKbd;
  final bool enableFootnote;
  final MarkdownImageBuilder? imageBuilder;
  final MarkdownStyle? styleSheet;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownListItemMarkerBuilder? listItemMarkerBuilder;
  final MarkdownCheckboxBuilder? checkboxBuilder;
  final MarkdownHighlightBuilder? highlightBuilder;
  final List<MarkdownElementBuilder> elementBuilders;
  final List<md.Syntax> syntaxExtensions;

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

    log(widget.toPrettyString());
    return widget;
  }

  void _parseMarkdown() {
    final theme = Theme.of(context);
    final md.Document document = md.Document(
      enableHtmlBlock: false,
      enableRawHtml: false,
      enableHighlight: true,
      enableStrikethrough: true,
      enableTaskList: widget.enableTaskList,
      enableSubscript: widget.enableSubscript,
      enableSuperscript: widget.enableSuperscript,
      enableKbd: widget.enableKbd,
      enableFootnote: widget.enableFootnote,
      extensions: widget.syntaxExtensions,
    );
    final renderer = MarkdownRenderer(
      styleSheet: widget.styleSheet ?? MarkdownStyle.fromTheme(theme),
      onTapLink: widget.onTapLink,
      enableImageSize: widget.enableImageSize,
      imageBuilder: widget.imageBuilder,
      listItemMarkerBuilder: widget.listItemMarkerBuilder,
      checkboxBuilder: widget.checkboxBuilder,
      highlightBuilder: widget.highlightBuilder,
      elementBuilders: widget.elementBuilders,
    );
    final astNodes = document.parseLines(widget.data);

    _children = renderer.render(astNodes);
  }
}
