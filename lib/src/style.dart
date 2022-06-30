import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownStyle {
  MarkdownStyle({
    this.paragraph,
    this.blockquote,
    this.htmlBlock,
    this.list,
    this.listItem,
    this.table,
    this.tableHead,
    this.tableBody,
    this.headline1,
    this.headline2,
    this.headline3,
    this.headline4,
    this.headline5,
    this.headline6,
    this.emphasis,
    this.strongEmphasis,
    this.link,
    this.inlineHtml,
    this.codeBlock,
    this.inlineCode,
  });

  MarkdownStyle.fromTheme(
    ThemeData theme, [
    MarkdownStyle? withStyle,
  ])  : paragraph = withStyle?.paragraph ?? theme.textTheme.bodyText2,
        blockquote = withStyle?.blockquote ?? theme.textTheme.bodyText2,
        htmlBlock = withStyle?.htmlBlock ?? theme.textTheme.bodyText2,
        list = withStyle?.list ?? theme.textTheme.bodyText2,
        listItem = withStyle?.listItem,
        table = withStyle?.table,
        tableHead = withStyle?.tableHead ??
            const TextStyle(fontWeight: FontWeight.w600),
        tableBody = withStyle?.tableBody ?? theme.textTheme.bodyText2,
        headline1 = withStyle?.headline1 ?? theme.textTheme.headline5,
        headline2 = withStyle?.headline2 ?? theme.textTheme.headline6,
        headline3 = withStyle?.headline3 ?? theme.textTheme.bodyText1,
        headline4 = withStyle?.headline4 ?? theme.textTheme.bodyText1,
        headline5 = withStyle?.headline5 ?? theme.textTheme.bodyText1,
        headline6 = withStyle?.headline6 ?? theme.textTheme.bodyText1,
        emphasis =
            withStyle?.emphasis ?? const TextStyle(fontStyle: FontStyle.italic),
        strongEmphasis = withStyle?.strongEmphasis ??
            const TextStyle(fontWeight: FontWeight.w700),
        link = withStyle?.link ?? TextStyle(color: theme.colorScheme.primary),
        inlineHtml = withStyle?.inlineHtml ??
            theme.textTheme.bodyText2!.copyWith(
              backgroundColor: theme.cardTheme.color ?? theme.cardColor,
              fontFamily: 'monospace',
            ),
        codeBlock = withStyle?.codeBlock,
        inlineCode = withStyle?.inlineCode ??
            theme.textTheme.bodyText2!.copyWith(
              backgroundColor: theme.cardTheme.color ?? theme.cardColor,
              fontFamily: 'monospace',
              fontSize: theme.textTheme.bodyText2!.fontSize! * 0.85,
            );

  final TextStyle? paragraph;
  final TextStyle? blockquote;
  final TextStyle? htmlBlock;
  final TextStyle? list;
  final TextStyle? listItem;
  final TextStyle? table;
  final TextStyle? tableHead;
  final TextStyle? tableBody;
  final TextStyle? headline1;
  final TextStyle? headline2;
  final TextStyle? headline3;
  final TextStyle? headline4;
  final TextStyle? headline5;
  final TextStyle? headline6;
  final TextStyle? emphasis;
  final TextStyle? strongEmphasis;
  final TextStyle? link;
  final TextStyle? inlineHtml;
  final TextStyle? codeBlock;
  final TextStyle? inlineCode;

  /// Generates a [TextStyle].
  TextStyle style(md.Element element, TextStyle? parentStyle) {
    final type = element.type;
    TextStyle? style;

    switch (type) {
      case 'paragraph':
        style = paragraph;
        break;

      case 'blockquote':
      case 'fencedBlockquote':
        style = blockquote;
        break;

      case 'htmlBlock':
        style = htmlBlock;
        break;

      case 'bulletList':
      case 'orderedList':
        style = list;
        break;

      case 'listItem':
        style = listItem;
        break;

      case 'table':
        style = table;
        break;

      case 'tableHead':
        style = tableHead;
        break;

      case 'tableBody':
        style = tableBody;
        break;

      case 'atxHeading':
      case 'setextHeading':
        style = {
          "1": headline1,
          "2": headline2,
          "3": headline3,
          "4": headline4,
          "5": headline5,
          "6": headline6,
        }[element.attributes['level']];
        break;

      case 'emphasis':
        style = emphasis;
        break;

      case 'strongEmphasis':
        style = strongEmphasis;
        break;

      case 'link':
      case 'autolink':
      case 'extendedAutolink':
        style = link;
        break;

      case 'indentedCodeBlock':
      case 'fencedCodeBlock':
        style = codeBlock;
        break;

      case 'codeSpan':
        style = inlineCode;
        break;

      case 'rawHtml':
        style = inlineHtml;
        break;
    }

    style ??= const TextStyle();

    if (parentStyle != null) {
      style = parentStyle.merge(style);
    }

    return style;
  }
}
