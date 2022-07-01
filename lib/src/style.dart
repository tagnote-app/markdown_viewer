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

  /// Creates a [MarkdownStyle] from the [TextStyle]s in the provided [theme].
  /// Also it allows to set individual [TextStyle]s which will be merged into
  /// the [TextStyle]s generated from [theme].
  MarkdownStyle.fromTheme(
    ThemeData theme, {
    TextStyle? paragraph,
    TextStyle? blockquote,
    TextStyle? htmlBlock,
    TextStyle? list,
    this.listItem,
    this.table,
    TextStyle? tableHead,
    TextStyle? tableBody,
    TextStyle? headline1,
    TextStyle? headline2,
    TextStyle? headline3,
    TextStyle? headline4,
    TextStyle? headline5,
    TextStyle? headline6,
    TextStyle? emphasis,
    TextStyle? strongEmphasis,
    TextStyle? link,
    TextStyle? inlineHtml,
    this.codeBlock,
    TextStyle? inlineCode,
  })  : paragraph = theme.textTheme.bodyText2?.merge(paragraph),
        blockquote = theme.textTheme.bodyText2?.merge(blockquote),
        htmlBlock = theme.textTheme.bodyText2?.merge(htmlBlock),
        list = theme.textTheme.bodyText2?.merge(list),
        tableHead =
            const TextStyle(fontWeight: FontWeight.w600).merge(tableHead),
        tableBody = theme.textTheme.bodyText2?.merge(tableBody),
        headline1 = theme.textTheme.headline5?.merge(headline1),
        headline2 = theme.textTheme.headline6?.merge(headline2),
        headline3 = theme.textTheme.bodyText1?.merge(headline3),
        headline4 = theme.textTheme.bodyText1?.merge(headline4),
        headline5 = theme.textTheme.bodyText1?.merge(headline5),
        headline6 = theme.textTheme.bodyText1?.merge(headline6),
        emphasis = const TextStyle(fontStyle: FontStyle.italic).merge(emphasis),
        strongEmphasis =
            const TextStyle(fontWeight: FontWeight.w700).merge(strongEmphasis),
        link = TextStyle(color: theme.colorScheme.primary).merge(link),
        inlineHtml = theme.textTheme.bodyText2!
            .copyWith(
              backgroundColor: theme.cardTheme.color ?? theme.cardColor,
              fontFamily: 'monospace',
            )
            .merge(inlineHtml),
        inlineCode = theme.textTheme.bodyText2!
            .copyWith(
              backgroundColor: theme.cardTheme.color ?? theme.cardColor,
              fontFamily: 'monospace',
              fontSize: theme.textTheme.bodyText2!.fontSize! * 0.85,
            )
            .merge(inlineCode);

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
