import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'extensions.dart';

class TreeElement {
  TreeElement.root()
      : type = '',
        style = null,
        attributes = const {};

  TreeElement.fromAstElement(md.Element element, {this.style})
      : type = element.type,
        attributes = element.attributes;

  bool get isRoot => type.isEmpty;
  final String type;
  final TextStyle? style;

  final Map<String, String> attributes;

  final List<Widget> children = <Widget>[];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'attributes': attributes,
      'children': children.map((e) => e.toMap()).toList(),
      'style': style,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  String toPrettyString() {
    return toMap().toPrettyString();
  }
}
