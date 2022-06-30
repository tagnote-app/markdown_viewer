import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

final _theme = ThemeData(
  textTheme: const TextTheme(
    headline5: TextStyle(
      fontFamily: '.SF UI Display',
      fontWeight: FontWeight.w400,
      fontSize: 24.0,
      color: Color(0xdd000000),
    ),
    headline6: TextStyle(
      fontFamily: '.SF UI Display',
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
      color: Color(0xdd000000),
    ),
    subtitle1: TextStyle(
      fontFamily: '.SF UI Text',
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      color: Color(0xdd000000),
    ),
    bodyText1: TextStyle(
      fontFamily: '.SF UI Text',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      color: Color(0xdd000000),
    ),
    bodyText2: TextStyle(
      fontFamily: '.SF UI Text',
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      color: Color(0xdd000000),
    ),
  ),
);

class MarkdownStyleSheet {
  MarkdownStyleSheet({
    TextStyle? paragraph,
    TextStyle? blockquote,
    TextStyle? htmlBlock,
    TextStyle? list,
    TextStyle? listItem,
    TextStyle? table,
    TextStyle? tableHead,
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
    TextStyle? codeBlock,
    TextStyle? inlineCode,
  })  : _paragraph = paragraph ?? _theme.textTheme.bodyText2!,
        _blockquote = blockquote ?? _theme.textTheme.bodyText2!,
        _htmlBlock = htmlBlock ?? _theme.textTheme.bodyText2!,
        _list = list ?? _theme.textTheme.bodyText2!,
        _listItem = listItem ?? const TextStyle(),
        _table = table ?? _theme.textTheme.bodyText2!,
        _tableHead = tableHead ?? const TextStyle(fontWeight: FontWeight.w600),
        _headline1 = headline1 ?? _theme.textTheme.headline5!,
        _headline2 = headline2 ?? _theme.textTheme.headline6!,
        _headline3 = headline3 ?? _theme.textTheme.bodyText1!,
        _headline4 = headline4 ?? _theme.textTheme.bodyText1!,
        _headline5 = headline5 ?? _theme.textTheme.bodyText1!,
        _headline6 = headline6 ?? _theme.textTheme.bodyText1!,
        _emphasis = emphasis ?? const TextStyle(fontStyle: FontStyle.italic),
        _strongEmphasis =
            strongEmphasis ?? const TextStyle(fontWeight: FontWeight.w700),
        _link = link ?? const TextStyle(color: Color(0xff2196f3)),
        _inlineHtml = inlineHtml ?? const TextStyle(fontSize: 11.9),
        _codeBlock = codeBlock ?? const TextStyle(fontSize: 11.9),
        _inlineCode = inlineCode ?? const TextStyle(fontSize: 11.9);

  final TextStyle _paragraph;
  final TextStyle _blockquote;
  final TextStyle _htmlBlock;
  final TextStyle _list;
  final TextStyle _listItem;
  final TextStyle _table;
  final TextStyle _tableHead;
  final TextStyle _headline1;
  final TextStyle _headline2;
  final TextStyle _headline3;
  final TextStyle _headline4;
  final TextStyle _headline5;
  final TextStyle _headline6;
  final TextStyle _emphasis;
  final TextStyle _strongEmphasis;
  final TextStyle _link;
  final TextStyle _inlineHtml;
  final TextStyle _codeBlock;
  final TextStyle _inlineCode;

  TextStyle style(md.Element element, TextStyle? parentStyle) {
    final type = element.type;
    TextStyle style;

    switch (type) {
      case 'paragraph':
        style = _paragraph;
        break;

      case 'blockquote':
      case 'fencedBlockquote':
        style = _blockquote;
        break;

      case 'htmlBlock':
        style = _htmlBlock;
        break;

      case 'bulletList':
      case 'orderedList':
        style = _list;
        break;

      case 'listItem':
        style = _listItem;
        break;

      case 'table':
        style = _table;
        break;

      case 'tableHead':
        style = _tableHead;
        break;

      case 'atxHeading':
      case 'setextHeading':
        style = {
          "1": _headline1,
          "2": _headline2,
          "3": _headline3,
          "4": _headline4,
          "5": _headline5,
          "6": _headline6,
        }[element.attributes['level']]!;
        break;

      case 'emphasis':
        style = _emphasis;
        break;

      case 'strongEmphasis':
        style = _strongEmphasis;
        break;

      case 'link':
      case 'autolink':
      case 'extendedAutolink':
        style = _link;
        break;

      case 'indentedCodeBlock':
      case 'fencedCodeBlock':
        style = _codeBlock;
        break;

      case 'codeSpan':
        style = _inlineCode;
        break;

      case 'rawHtml':
        style = _inlineHtml;
        break;

      default:
        style = const TextStyle();
    }

    if (parentStyle != null) {
      style = parentStyle.merge(style);
    }

    return style;
  }
}
