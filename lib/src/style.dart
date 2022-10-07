import 'package:flutter/rendering.dart';

import 'definition.dart';

class MarkdownStyle {
  const MarkdownStyle({
    this.textStyle,
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
    this.paragraphPadding,
    this.blockquote,
    this.blockquoteDecoration,
    this.blockquotePadding,
    this.footnoteReferenceDecoration,
    this.footnoteReferencePadding,
    this.dividerColor,
    this.dividerHeight,
    this.dividerThickness,
    this.emphasis,
    this.strongEmphasis,
    this.highlight,
    this.strikethrough,
    this.subscript,
    this.superscript,
    this.kbd,
    this.footnote,
    this.footnoteReference,
    this.link,
    this.inlineCode,
    this.list,
    this.listItem,
    this.listItemMarker,
    // TODO: move default style to builder
    this.listItemMarkerPadding = const EdgeInsets.only(right: 12.0),
    this.listItemMinIndent = 30.0,
    this.checkbox,
    this.table,
    this.tableHead,
    this.tableBody,
    this.tableBorder,
    this.tableRowDecoration,
    this.tableRowDecorationAlternating,
    // TODO: move default style to builder
    this.tableCellPadding = const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
    this.tableColumnWidth = const FlexColumnWidth(),
    this.codeBlock,
    this.codeblockPadding,
    this.codeblockDecoration,
    this.blockSpacing = 8.0,
  });

  final TextStyle? textStyle;
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
  final EdgeInsets? paragraphPadding;
  final TextStyle? blockquote;
  final BoxDecoration? blockquoteDecoration;
  final EdgeInsets? blockquotePadding;
  final BoxDecoration? footnoteReferenceDecoration;
  final EdgeInsets? footnoteReferencePadding;
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
  final TextStyle? footnote;
  final TextStyle? footnoteReference;
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
