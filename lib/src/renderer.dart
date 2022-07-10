import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'ast.dart';
import 'builders/builder.dart';
import 'builders/code_block_builder.dart';
import 'builders/headline_builder.dart';
import 'builders/list_builder.dart';
import 'builders/simple_blocks_builder.dart';
import 'builders/simple_inlines_builder.dart';
import 'builders/table_bilder.dart';
import 'definition.dart';
import 'extensions.dart';
import 'helpers.dart';
import 'style.dart';
import 'transformer.dart';

class MarkdownRenderer implements NodeVisitor {
  MarkdownRenderer({
    required MarkdownStyle styleSheet,
    MarkdownTapLinkCallback? onTapLink,
    MarkdownListItemMarkerBuilder? listItemMarkerBuilder,
    MarkdownCheckboxBuilder? checkboxBuilder,
    MarkdownHighlightBuilder? highlightBuilder,
    List<MarkdownElementBuilder> elementBuilders = const [],
    bool selectable = false,
    TextAlign? textAlign,
  })  : _selectable = selectable,
        _blockSpacing = styleSheet.blockSpacing,
        _textAlign = textAlign ?? TextAlign.start {
    final defaultBuilders = [
      HeadlineBuilder(
        headline1: styleSheet.headline1,
        headline2: styleSheet.headline2,
        headline3: styleSheet.headline3,
        headline4: styleSheet.headline4,
        headline5: styleSheet.headline5,
        headline6: styleSheet.headline6,
        h1Padding: styleSheet.h1Padding,
        h2Padding: styleSheet.h2Padding,
        h3Padding: styleSheet.h3Padding,
        h4Padding: styleSheet.h4Padding,
        h5Padding: styleSheet.h5Padding,
        h6Padding: styleSheet.h6Padding,
      ),
      SimpleInlinesBuilder(
        emphasis: styleSheet.emphasis,
        strongEmphasis: styleSheet.strongEmphasis,
        highlight: styleSheet.highlight,
        strikethrough: styleSheet.strikethrough,
        link: styleSheet.link,
        inlineCode: styleSheet.inlineCode,
        onTapLink: onTapLink,
      ),
      SimpleBlocksBuilder(
        paragraph: styleSheet.paragraph,
        pPadding: styleSheet.pPadding,
        blockquote: styleSheet.blockquote,
        blockquoteDecoration: styleSheet.blockquoteDecoration,
        blockquotePadding: styleSheet.blockquotePadding,
        dividerColor: styleSheet.dividerColor,
        dividerHeight: styleSheet.dividerHeight,
        dividerThickness: styleSheet.dividerThickness,
      ),
      TableBuilder(
        table: styleSheet.table,
        tableHead: styleSheet.tableHead,
        tableBody: styleSheet.tableBody,
        tableBorder: styleSheet.tableBorder,
        tableRowDecoration: styleSheet.tableRowDecoration,
        tableRowDecorationAlternating: styleSheet.tableRowDecorationAlternating,
        tableCellPadding: styleSheet.tableCellPadding,
        tableColumnWidth: styleSheet.tableColumnWidth,
      ),
      CodeBlockBuilder(
        textStyle: styleSheet.codeBlock,
        codeblockPadding: styleSheet.codeblockPadding,
        codeblockDecoration: styleSheet.codeblockDecoration,
        highlightBuilder: highlightBuilder,
      ),
      ListBuilder(
        list: styleSheet.list,
        listItem: styleSheet.listItem,
        listItemMarker: styleSheet.listItemMarker,
        listItemMarkerPadding: styleSheet.listItemMarkerPadding,
        listItemMinIndent: styleSheet.listItemMinIndent,
        checkbox: styleSheet.checkbox,
        listItemMarkerBuilder: listItemMarkerBuilder,
        checkboxBuilder: checkboxBuilder,
      ),
    ];

    for (final builder in [...defaultBuilders, ...elementBuilders]) {
      for (final type in builder.matchTypes) {
        _builders[type] = builder;
      }
    }
  }

  final bool _selectable;
  final TextAlign _textAlign;
  final double _blockSpacing;

  String? _keepLineEndingsWhen;
  final _gestureRecognizers = <String, GestureRecognizer>{};

  final _tree = <_TreeElement>[];
  final _builders = <String, MarkdownElementBuilder>{};

  List<Widget> render(List<md.Node> nodes) {
    _tree.clear();
    _keepLineEndingsWhen = null;
    _gestureRecognizers.clear();

    _tree.add(_TreeElement.root());

    for (final MarkdownNode node in transformAst(nodes)) {
      assert(_tree.length == 1);
      node.accept(this);
    }

    assert(_keepLineEndingsWhen == null);
    assert(_gestureRecognizers.isEmpty);
    return _tree.single.children;
  }

  @override
  bool visitElementBefore(MarkdownElement element) {
    final type = element.type;
    final attributes = element.attributes;
    assert(_builders[type] != null, "No $type builder found");

    final parent = _tree.last;
    final builder = _builders[type]!;
    builder.before(type, attributes);

    builder.parentStyle = parent.style;
    if (builder.replaceLineEndings(type) == false) {
      _keepLineEndingsWhen = type;
    }
    _gestureRecognizers.addIfNotNull(
      type,
      builder.gestureRecognizer(type, attributes),
    );

    _tree.add(_TreeElement.fromAstElement(
      element,
      style: builder.buildTextStyle(type, attributes),
    ));
    return true;
  }

  @override
  void visitText(MarkdownText text) {
    final parent = _tree.last;
    final builder = _builders[parent.type]!;
    final textContent = _keepLineEndingsWhen == null
        ? text.text.replaceAll('\n', ' ')
        : text.text;
    var textSpan = builder.buildText(textContent, parent);
    final textAlign = builder.textAlign(parent) ?? _textAlign;

    if (_gestureRecognizers.isNotEmpty) {
      textSpan = TextSpan(
        text: textSpan.text,
        children: textSpan.children,
        semanticsLabel: textSpan.semanticsLabel,
        style: textSpan.style,
        recognizer: _gestureRecognizers.entries.last.value,
      );
    }

    parent.children.add(buildRichText(textSpan, textAlign));
  }

  @override
  void visitElementAfter(MarkdownElement element) {
    final current = _tree.removeLast();
    final type = current.type;
    final parent = _tree.last;
    final builder = _builders[type]!;

    final textSpan = builder.createText(type, parent.style);
    if (textSpan != null) {
      current.children.add(buildRichText(textSpan, _textAlign));
    }

    current.children.replaceRange(
      0,
      current.children.length,
      compressWidgets(current.children),
    );

    builder.after(this, current);

    if (_keepLineEndingsWhen == type) {
      _keepLineEndingsWhen = null;
    }
    _gestureRecognizers.remove(type);
  }

  /// Adds [child] to the the children of the parent element as a block element.
  ///
  /// It will and a spacing between block elements.
  void writeBlock(Widget child) {
    _tree.last.children.addAll([
      if (_tree.last.children.isNotEmpty) SizedBox(height: _blockSpacing),
      child,
    ]);
  }

  /// Adds [children] of current inline element as the children of the parent
  /// element.
  void writeInline(List<Widget> children) {
    _tree.last.children.addAll(children);
  }

  /// Merges the [RichText] elements of [children] and returns a [Column] if the
  /// [children] is not empty, otherwise returns a shrinked [SizedBox].
  Widget convertToBlock(List<Widget> children, {EdgeInsets? padding}) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    if (padding != null && padding != EdgeInsets.zero) {
      children = [
        Padding(
          padding: padding,
          child:
              children.length == 1 ? children.single : Wrap(children: children),
        )
      ];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  /// Builds a [RichText] widget. It will build a [SelectableText] rich text if
  /// [_selectable] is true.
  Widget buildRichText(TextSpan text, TextAlign textAlign) {
    if (_selectable) {
      return SelectableText.rich(
        text,
        textAlign: textAlign,
        onTap: () {},
      );
    } else {
      return RichText(
        text: text,
        textAlign: textAlign,
      );
    }
  }

  /// Merges the [RichText] elements of [widgets] while it is possible.
  List<Widget> compressWidgets(List<Widget> widgets) => mergeRichText(
        widgets,
        richTextBuilder: (span, textAlign) => buildRichText(
          span,
          textAlign ?? _textAlign,
        ),
      );
}

class _TreeElement extends MarkdownTreeElement {
  _TreeElement.root() : super(type: '', style: null, attributes: const {});

  _TreeElement.fromAstElement(MarkdownElement element, {TextStyle? style})
      : super(type: element.type, attributes: element.attributes, style: style);
}
