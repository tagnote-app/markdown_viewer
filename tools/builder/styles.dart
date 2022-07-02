import 'package:markdown/markdown.dart';

import 'tree_element.dart';

/// The default theme.
const _theme = {
  'headline5': {
    'fontFamily': '.SF UI Display',
    'fontWeight': 400,
    'fontSize': 24.0,
    'color': 'Color(0xdd000000)',
  },
  'headline6': {
    'fontFamily': '.SF UI Display',
    'fontWeight': 500,
    'fontSize': 20.0,
    'color': 'Color(0xdd000000)',
  },
  'subtitle1': {
    'fontFamily': '.SF UI Text',
    'fontWeight': 400,
    'fontSize': 16.0,
    'color': 'Color(0xdd000000)',
  },
  'bodyText1': {
    'fontFamily': '.SF UI Text',
    'fontWeight': 500,
    'fontSize': 14.0,
    'color': 'Color(0xdd000000)',
  },
  'bodyText2': {
    'fontFamily': '.SF UI Text',
    'fontWeight': 400,
    'fontSize': 14.0,
    'color': 'Color(0xdd000000)',
  },
};

/// Generates a style map from an AST Element [element] and [parentStyle].
Map<String, dynamic> generateStyle(
  Element element,
  Map<String, dynamic> parentStyle,
) {
  String? fontFamily = parentStyle['fontFamily'];
  int? fontWeight = parentStyle['fontWeight'];
  double? fontSize = parentStyle['fontSize'];
  String? fontStyle = parentStyle['fontStyle'];
  String? color = parentStyle['color'];

  switch (element.type) {
    case 'paragraph':
    case 'blockquote':
    case 'fencedBlockquote':
    case 'bulletList':
    case 'orderedList':
    case 'table':
      fontFamily = _theme['bodyText2']!['fontFamily'] as String;
      fontWeight = _theme['bodyText2']!['fontWeight'] as int;
      fontSize = _theme['bodyText2']!['fontSize'] as double;
      color = _theme['bodyText2']!['color'] as String;
      break;

    case 'indentedCodeBlock':
    case 'fencedCodeBlock':
    case 'htmlBlock':
      fontFamily = 'monospace';
      fontWeight = _theme['bodyText2']!['fontWeight'] as int;
      fontSize = (_theme['bodyText2']!['fontSize'] as double) * 0.85;
      color = _theme['bodyText2']!['color'] as String;
      break;

    case 'tableHead':
      fontWeight = 600;
      break;

    case 'atxHeading':
    case 'setextHeading':
      final headingStyle = {
        "1": _theme['headline5'],
        "2": _theme['headline6'],
        "3": _theme['subtitle1'],
        "4": _theme['bodyText1'],
        "5": _theme['bodyText1'],
        "6": _theme['bodyText1'],
      }[element.attributes['level']]!;
      fontFamily = headingStyle['fontFamily'] as String;
      fontWeight = headingStyle['fontWeight'] as int;
      fontSize = headingStyle['fontSize'] as double;
      color = headingStyle['color'] as String;
      break;

    case 'emphasis':
      fontStyle = 'italic';
      break;

    case 'strongEmphasis':
      fontWeight = 700;
      break;

    case 'link':
    case 'autolink':
    case 'extendedAutolink':
      // `Colors.blue[500]`
      color = 'Color(0xff2196f3)';
      break;

    case 'codeSpan':
    case 'rawHtml':
      fontFamily = 'monospace';
      fontSize = (_theme['bodyText2']!['fontSize'] as double) * 0.85;
      break;
  }

  return <String, dynamic>{
    if (fontFamily != null) 'fontFamily': fontFamily,
    if (fontWeight != null) 'fontWeight': fontWeight,
    if (fontSize != null) 'fontSize': fontSize,
    if (fontStyle != null) 'fontStyle': fontStyle,
    if (color != null) 'color': color,
  };
}

/// Checkes if [span1] and [span2] have the same attributes.
bool haveSameAttributes(TextSpan span1, TextSpan span2) {
  span1 = {...span1, 'text': null};
  span2 = {...span2, 'text': null};

  for (final key in span1.keys) {
    if (span1[key] != span2[key]) {
      return false;
    }
    span2.remove(key);
  }

  return span2.isEmpty;
}
