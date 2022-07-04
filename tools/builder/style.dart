import 'package:markdown/markdown.dart';

import 'elements.dart';

/// The default theme.
final _textTheme = {
  'headline5': const TextStyle(
    fontFamily: '.SF UI Display',
    fontSize: 24.0,
  ),
  'headline6': const TextStyle(
    fontFamily: '.SF UI Display',
    fontWeight: 'FontWeight.w500',
    fontSize: 20.0,
  ),
  'subtitle1': const TextStyle(
    fontSize: 16.0,
  ),
  'bodyText1': const TextStyle(
    fontWeight: 'FontWeight.w500',
  ),
  'bodyText2': const TextStyle(),
};

TextStyle generateTextStyle(
  Element element,
  TextStyle? parentStyle,
) {
  final paragraph = _textTheme['bodyText2']!;
  final blockquote = _textTheme['bodyText2']!.copyWith(
    color: 'Color(0xff666666)',
  );
  final list = _textTheme['bodyText2']!;
  final tableBody = _textTheme['bodyText2'];
  final headline1 = _textTheme['headline5'];
  final headline2 = _textTheme['headline6'];
  final headline3 = _textTheme['subtitle1'];
  final headline4 = _textTheme['bodyText1'];
  final headline5 = _textTheme['bodyText1'];
  final headline6 = _textTheme['bodyText1'];
  //
  const code = TextStyle(fontFamily: 'monospace', fontSize: 12);
  //
  // TODO: Fix the colors for codes
  final htmlBlock = code.copyWith(backgroundColor: '');
  final inlineHtml = code.copyWith(color: '');
  final codeBlock = code.copyWith(color: '');
  final inlineCode = code.copyWith(backgroundColor: '');
  const listItem = TextStyle();
  const table = TextStyle();
  const tableHead = TextStyle();
  const emphasis = TextStyle(fontStyle: 'FontStyle.italic');
  const strongEmphasis = TextStyle(fontWeight: 'FontWeight.w700');
  const link = TextStyle(color: 'Color(0xff2196f3)');

  final type = element.type;
  TextStyle? style;

  switch (type) {
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

  const emptyStyle = TextStyle();
  style ??= emptyStyle;

  if (parentStyle != null) {
    style = parentStyle.merge(style);
  }

  if (type == 'paragraph') {
    style = paragraph.merge(style);
  }

  return style;
}
