import 'package:markdown/markdown.dart';

import 'helpers.dart';

typedef TextSpan = Map<String, dynamic>;

class TreeElement {
  TreeElement.root()
      : type = '',
        style = const {},
        isBlock = false;

  TreeElement.fromAstElement(Element element, {required this.style})
      : type = element.type,
        isBlock = isBlockElement(element.type);

  final String type;
  final bool isBlock;
  final Map<String, dynamic> style;

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
