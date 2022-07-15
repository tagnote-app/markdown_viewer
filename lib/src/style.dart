import 'dart:ui';
import 'package:flutter/material.dart';

import 'definition.dart';

const _tableBorderSide = BorderSide(color: Color(0xffcccccc));
const _tableBorder = TableBorder(
  top: _tableBorderSide,
  left: _tableBorderSide,
  right: _tableBorderSide,
  bottom: _tableBorderSide,
  horizontalInside: _tableBorderSide,
  verticalInside: _tableBorderSide,
);

class MarkdownStyle {
  MarkdownStyle({
    this.headline1,
    this.headline2,
    this.headline3,
    this.headline4,
    this.headline5,
    this.headline6,
    this.h1Padding,
    this.h2Padding,
    this.h3Padding,
    this.h4Padding,
    this.h5Padding,
    this.h6Padding,
    this.paragraph,
    this.pPadding,
    this.blockquote,
    this.blockquoteDecoration,
    this.blockquotePadding = const EdgeInsets.all(8.0),
    this.dividerColor,
    this.dividerHeight,
    this.dividerThickness,
    this.emphasis = const TextStyle(fontStyle: FontStyle.italic),
    this.strongEmphasis = const TextStyle(fontWeight: FontWeight.w700),
    this.highlight = const TextStyle(backgroundColor: Color(0xffffee00)),
    this.strikethrough =
        const TextStyle(decoration: TextDecoration.lineThrough),
    this.subscript = const TextStyle(fontFeatures: [FontFeature.subscripts()]),
    this.superscript =
        const TextStyle(fontFeatures: [FontFeature.superscripts()]),
    this.kbd,
    this.link = const TextStyle(color: Color(0xff2196f3)),
    this.inlineCode = const TextStyle(fontFamily: 'monospace'),
    this.list,
    this.listItem,
    this.listItemMarker,
    this.listItemMarkerPadding = const EdgeInsets.only(right: 12.0),
    this.listItemMinIndent = 30.0,
    this.checkbox = const TextStyle(fontSize: 18.0),
    this.table,
    this.tableHead = const TextStyle(fontWeight: FontWeight.w600),
    this.tableBody,
    this.tableBorder = _tableBorder,
    this.tableRowDecoration,
    this.tableRowDecorationAlternating,
    this.tableCellPadding = const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
    this.tableColumnWidth = const FlexColumnWidth(),
    this.codeBlock = const TextStyle(fontFamily: 'monospace'),
    this.codeblockPadding = const EdgeInsets.all(8.0),
    this.codeblockDecoration,
    this.blockSpacing = 8.0,
  });

  /// Creates a [MarkdownStyle] from the [TextStyle]s in the provided [theme].
  /// Also it allows to set individual [TextStyle]s which will be merged into
  /// the [TextStyle]s generated from [theme].
  factory MarkdownStyle.fromTheme(
    ThemeData theme, {
    TextStyle? headline1,
    TextStyle? headline2,
    TextStyle? headline3,
    TextStyle? headline4,
    TextStyle? headline5,
    TextStyle? headline6,
    EdgeInsets? h1Padding,
    EdgeInsets? h2Padding,
    EdgeInsets? h3Padding,
    EdgeInsets? h4Padding,
    EdgeInsets? h5Padding,
    EdgeInsets? h6Padding,
    TextStyle? paragraph,
    EdgeInsets? pPadding,
    TextStyle? blockquote,
    BoxDecoration? blockquoteDecoration,
    EdgeInsets? blockquotePadding,
    Color? dividerColor,
    double? dividerHeight,
    double? dividerThickness,
    TextStyle? emphasis,
    TextStyle? strongEmphasis,
    TextStyle? highlight,
    TextStyle? strikethrough,
    TextStyle? subscript,
    TextStyle? superscript,
    TextStyle? kbd,
    TextStyle? link,
    TextStyle? inlineCode,
    TextStyle? list,
    TextStyle? listItem,
    TextStyle? listItemMarker,
    EdgeInsets? listItemMarkerPadding,
    double? listItemMinIndent,
    TextStyle? checkbox,
    TextStyle? table,
    TextStyle? tableHead,
    TextStyle? tableBody,
    TableBorder? tableBorder = _tableBorder,
    BoxDecoration? tableRowDecoration,
    MarkdownAlternating? tableRowDecorationAlternating,
    EdgeInsets? tableCellPadding,
    TableColumnWidth? tableColumnWidth,
    TextStyle? codeBlock,
    EdgeInsets? codeblockPadding,
    BoxDecoration? codeblockDecoration,
    double? blockSpacing,
  }) {
    final style = MarkdownStyle();
    final textTheme = theme.textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    final codeStyle = bodyText2.copyWith(
      fontSize: textTheme.bodyText2!.fontSize! * 0.85,
    );

    return MarkdownStyle(
      headline1: textTheme.headline5?.merge(headline1),
      headline2: textTheme.headline6?.merge(headline2),
      headline3: textTheme.subtitle1?.merge(headline3),
      headline4: bodyText1.merge(headline4),
      headline5: bodyText1.merge(headline5),
      headline6: bodyText1.merge(headline6),
      h1Padding: h1Padding,
      h2Padding: h2Padding,
      h3Padding: h3Padding,
      h4Padding: h4Padding,
      h5Padding: h5Padding,
      h6Padding: h6Padding,
      paragraph: bodyText2.merge(paragraph),
      pPadding: pPadding,
      blockquote: bodyText2.merge(blockquote),
      blockquoteDecoration: blockquoteDecoration,
      blockquotePadding: blockquotePadding ?? style.blockquotePadding,
      dividerColor: dividerColor,
      dividerHeight: dividerHeight,
      dividerThickness: dividerThickness,
      emphasis: style.emphasis?.merge(emphasis),
      strongEmphasis: style.strongEmphasis?.merge(strongEmphasis),
      highlight: style.highlight?.merge(highlight),
      strikethrough: style.strikethrough?.merge(strikethrough),
      subscript: style.subscript?.merge(subscript),
      superscript: style.superscript?.merge(superscript),
      kbd: style.kbd?.merge(kbd),
      link: style.link?.merge(link),
      inlineCode: codeStyle.merge(style.inlineCode).merge(inlineCode),
      list: bodyText2.merge(list),
      listItem: listItem,
      listItemMarker: listItemMarker,
      listItemMarkerPadding:
          listItemMarkerPadding ?? style.listItemMarkerPadding,
      listItemMinIndent: listItemMinIndent ?? style.listItemMinIndent,
      checkbox: style.checkbox?.merge(checkbox),
      table: table,
      tableHead: bodyText2.merge(style.tableHead).merge(tableHead),
      tableBody: bodyText2.merge(tableBody),
      tableBorder: tableBorder,
      tableRowDecoration: tableRowDecoration,
      tableRowDecorationAlternating: tableRowDecorationAlternating,
      tableCellPadding: tableCellPadding ?? style.tableCellPadding,
      tableColumnWidth: tableColumnWidth ?? style.tableColumnWidth,
      codeBlock: codeStyle.merge(style.codeBlock).merge(codeBlock),
      codeblockPadding: codeblockPadding ?? style.codeblockPadding,
      codeblockDecoration: codeblockDecoration,
      blockSpacing: blockSpacing ?? style.blockSpacing,
    );
  }

  final TextStyle? headline1;
  final TextStyle? headline2;
  final TextStyle? headline3;
  final TextStyle? headline4;
  final TextStyle? headline5;
  final TextStyle? headline6;
  final EdgeInsets? h1Padding;
  final EdgeInsets? h2Padding;
  final EdgeInsets? h3Padding;
  final EdgeInsets? h4Padding;
  final EdgeInsets? h5Padding;
  final EdgeInsets? h6Padding;
  final TextStyle? paragraph;
  final EdgeInsets? pPadding;
  final TextStyle? blockquote;
  final BoxDecoration? blockquoteDecoration;
  final EdgeInsets blockquotePadding;
  final Color? dividerColor;
  final double? dividerHeight;
  final double? dividerThickness;
  final TextStyle? emphasis;
  final TextStyle? strongEmphasis;
  final TextStyle? highlight;
  final TextStyle? strikethrough;
  final TextStyle? subscript;
  final TextStyle? superscript;
  final TextStyle? kbd;
  final TextStyle? link;
  final TextStyle? inlineCode;
  final TextStyle? list;
  final TextStyle? listItem;
  final TextStyle? listItemMarker;
  final EdgeInsets listItemMarkerPadding;
  final double listItemMinIndent;
  final TextStyle? checkbox;
  final TextStyle? table;
  final TextStyle? tableHead;
  final TextStyle? tableBody;
  final TableBorder? tableBorder;
  final BoxDecoration? tableRowDecoration;
  final MarkdownAlternating? tableRowDecorationAlternating;
  final EdgeInsets tableCellPadding;
  final TableColumnWidth tableColumnWidth;
  final TextStyle? codeBlock;
  final EdgeInsets? codeblockPadding;
  final BoxDecoration? codeblockDecoration;

  /// The vertical space between two block elements.
  final double blockSpacing;
}
