import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

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
import 'tree_element.dart';

class MarkdownRenderer implements md.NodeVisitor {
  MarkdownRenderer({
    required MarkdownStyle styleSheet,
    MarkdownTapLinkCallback? onTapLink,
    MarkdownListItemMarkerBuilder? listItemMarkerBuilder,
    MarkdownCheckboxBuilder? checkboxBuilder,
    MarkdownHighlightBuilder? highlightBuilder,
    List<MarkdownElementBuilder> builders = const [],
    this.selectable = false,
  }) {
    final defaultBuilders = [
      HeadlineBuilder(
        headline1: styleSheet.headline1,
        headline2: styleSheet.headline2,
        headline3: styleSheet.headline3,
        headline4: styleSheet.headline4,
        headline5: styleSheet.headline5,
        headline6: styleSheet.headline6,
      ),
      SimpleInlinesBuilder(
        emphasis: styleSheet.emphasis,
        strongEmphasis: styleSheet.strongEmphasis,
        inlineCode: styleSheet.inlineCode,
        highlight: styleSheet.highlight,
        strikethrough: styleSheet.strikethrough,
        link: styleSheet.link,
        onTapLink: onTapLink,
      ),
      SimpleBlocksBuilder(
        paragraph: styleSheet.paragraph,
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
        tableCellPadding: styleSheet.tableCellPadding,
        tableColumnWidth: styleSheet.tableColumnWidth,
        tableBorder: styleSheet.tableBorder,
        tableHeadCellAlign: styleSheet.tableHeadCellAlign,
        tableRowDecoration: styleSheet.tableRowDecoration,
        tableRowDecorationAlternating: styleSheet.tableRowDecorationAlternating,
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
      ),
    ];

    for (final builder in [...defaultBuilders, ...builders]) {
      for (final type in builder.matchTypes) {
        _builders[type] = builder;
      }
    }
  }

  final bool selectable;

  String? _keepLineEndingsWhen;
  final _gestureRecognizers = <String, GestureRecognizer>{};

  final _tree = <TreeElement>[];
  final _builders = <String, MarkdownElementBuilder>{};

  List<Widget> render(List<md.Node> nodes) {
    _tree.clear();
    _keepLineEndingsWhen = null;
    _gestureRecognizers.clear();

    _tree.add(TreeElement.root());

    for (final md.Node node in nodes) {
      assert(_tree.length == 1);
      node.accept(this);
    }

    assert(_keepLineEndingsWhen == null);
    assert(_gestureRecognizers.isEmpty);
    return _tree.single.children;
  }

  @override
  bool visitElementBefore(md.Element element) {
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

    _tree.add(TreeElement.fromAstElement(
      element,
      style: builder.buildTextStyle(type, attributes),
    ));
    return true;
  }

  @override
  void visitText(md.Text text) {
    final parent = _tree.last;
    final builder = _builders[parent.type]!;
    final textContent = _keepLineEndingsWhen == null
        ? text.textContent.replaceAll('\n', ' ')
        : text.textContent;
    var textSpan = builder.buildText(textContent, parent);

    if (_gestureRecognizers.isNotEmpty) {
      textSpan = TextSpan(
        text: textSpan.text,
        children: textSpan.children,
        semanticsLabel: textSpan.semanticsLabel,
        style: textSpan.style,
        recognizer: _gestureRecognizers.entries.last.value,
      );
    }

    parent.children.add(buildRichText(textSpan));
  }

  @override
  void visitElementAfter(md.Element element) {
    final current = _tree.removeLast();
    final type = current.type;
    final parent = _tree.last;
    final builder = _builders[type]!;

    final textSpan = builder.createText(type, parent.style);
    if (textSpan != null) {
      current.children.add(buildRichText(textSpan));
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

  // Adds [child] to the the children of the parent element.
  void write(Widget child) {
    _tree.last.children.add(child);
  }

  // Adds [children] to the the children of the parent element.
  void writeAll(List<Widget> children) {
    _tree.last.children.addAll(children);
  }

  /// Merges the [RichText] elements of [children] and returns a [Column] if the
  /// [children] is not empty, otherwise returns a shrinked [SizedBox].
  Widget convertToBlock(List<Widget> children, {TextAlign? textAlign}) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget buildRichText(TextSpan text, {TextAlign? textAlign}) {
    if (selectable) {
      return SelectableText.rich(
        text,
        textAlign: textAlign ?? TextAlign.start,
        onTap: () {},
      );
    } else {
      return RichText(
        text: text,
        textAlign: textAlign ?? TextAlign.start,
      );
    }
  }

  /// Merges the [RichText] elements of [widgets] while it is possible.
  List<Widget> compressWidgets(List<Widget> widgets) => mergeRichText(
        widgets,
        richTextBuilder: (span, textAlign) =>
            buildRichText(span, textAlign: textAlign),
      );
}


// 'paragraph',
// 'headline',
// 'htmlBlock',
// 'codeBlock',
// 'bulletList',
// 'orderedList',
// 'listItem',
// 'thematicBreak',
// 'blockquote',
// 'table',
// 'tableRow',
// 'tableHead',
// 'tableBody',
// link
// image
// hardLineBreak
// highlight
// emphasis
// strongEmphasis
// emoji
// inlineCode
// inlineHtml
// tableBodyCell
// tableHeadCell

// linkReferenceDefinition
// linkReferenceDefinitionLabel
// linkReferenceDefinitionDestination
// linkReferenceDefinitionTitle