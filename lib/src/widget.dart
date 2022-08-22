import 'package:dart_markdown/dart_markdown.dart' as md;
import 'package:flutter/material.dart';

import 'builders/builder.dart';
import 'definition.dart';
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
    this.enableAutolinkExtension = true,
    this.enableImageSize = false,
    this.elementBuilders = const [],
    this.syntaxExtensions = const [],
    this.selectable = false,
    this.nodesFilter,
    Key? key,
  }) : super(key: key);

  final String data;
  final bool enableTaskList;
  final bool enableImageSize;
  final bool enableSubscript;
  final bool enableSuperscript;
  final bool enableKbd;
  final bool enableFootnote;
  final bool enableAutolinkExtension;
  final MarkdownImageBuilder? imageBuilder;
  final MarkdownStyle? styleSheet;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownListItemMarkerBuilder? listItemMarkerBuilder;
  final MarkdownCheckboxBuilder? checkboxBuilder;
  final MarkdownHighlightBuilder? highlightBuilder;
  final List<MarkdownElementBuilder> elementBuilders;
  final List<md.Syntax> syntaxExtensions;
  final bool selectable;

  /// A function used to modify the parsed AST nodes.
  ///
  /// It is useful for example when need to check if the parsed result contains
  /// any text content:
  ///
  /// ```dart
  /// nodesFilter: (nodes) {
  ///   if (nodes.map((e) => e.textContent).join().isNotEmpty) {
  ///     return nodes;
  ///   }
  ///   return [
  ///     md.BlockElement(
  ///       'paragraph',
  ///       children: [md.Text.fromString('empty')],
  ///     )
  ///   ];
  /// }
  /// ```
  final List<md.Node> Function(List<md.Node> nodes)? nodesFilter;

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
      enableAutolinkExtension: widget.enableAutolinkExtension,
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
      selectable: widget.selectable,
    );

    var astNodes = document.parseLines(widget.data);
    if (widget.nodesFilter != null) {
      astNodes = widget.nodesFilter!(astNodes);
    }

    _children = renderer.render(astNodes);
  }
}
