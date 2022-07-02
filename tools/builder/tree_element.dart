import 'package:markdown/markdown.dart';

import 'helpers.dart';

typedef TextSpan = Map<String, dynamic>;

class TreeElement {
  TreeElement.root()
      : type = '',
        isBlock = false;

  TreeElement.fromAstElement(Element element, TreeElement parent)
      : type = _transformType(
          element.type,
          parent: parent,
          level: element.attributes['level'],
        ),
        isBlock = isBlockElement(element.type);

  final String type;
  final bool isBlock;

  bool get isRoot => type.isEmpty;

  final children = <Map<String, dynamic>>[];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'children': children,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

String _transformType(
  String type, {
  required TreeElement parent,
  String? level,
}) {
  switch (type) {
    case 'atxHeading':
    case 'setextHeading':
      return {
        "1": 'headline1',
        "2": 'headline2',
        "3": 'headline3',
        "4": 'headline4',
        "5": 'headline5',
        "6": 'headline6',
      }[level!]!;

    case 'link':
    case 'autolink':
    case 'extendedAutolink':
      return 'link';

    case 'fencedBlockquote':
      return 'blockquote';

    case 'indentedCodeBlock':
    case 'fencedCodeBlock':
      return 'codeBlock';

    case 'codeSpan':
      return 'inlineCode';

    case 'rawHtml':
      return 'inlineHtml';

    case 'backslashEscape':
      return parent.isBlock ? 'text' : parent.type;
  }

  return type;
}
