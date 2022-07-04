import 'package:markdown/markdown.dart';

import '../extensions.dart';
import 'helpers.dart';

class TreeElement {
  TreeElement.root()
      : type = '',
        style = null,
        attributes = const {},
        isBlock = false;

  TreeElement.fromAstElement(Element element, {this.style})
      : type = element.type,
        isBlock = isBlockElement(element.type),
        attributes = element.attributes;

  bool get isRoot => type.isEmpty;
  final String type;
  final bool isBlock;
  final TextStyle? style;

  final Map<String, String> attributes;

  final List<Widget> children = <Widget>[];
}

abstract class Widget {
  Map<String, dynamic> toMap();
  String toPrettyString();
}

class TextStyle {
  const TextStyle({
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.backgroundColor,
  });
  TextStyle copyWith({
    String? fontFamily,
    String? fontWeight,
    String? fontStyle,
    double? fontSize,
    String? color,
    String? backgroundColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? this.fontFamily,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      color: color ?? this.color,
    );
  }

  TextStyle merge(TextStyle other) => copyWith(
        fontFamily: other.fontFamily,
        fontSize: other.fontSize,
        fontStyle: other.fontStyle,
        fontWeight: other.fontWeight,
        color: other.color,
        backgroundColor: other.backgroundColor,
      );

  final String? fontFamily;
  final String? fontWeight;
  final String? fontStyle;
  final double? fontSize;
  final String? color;
  final String? backgroundColor;

  bool get isEmpty =>
      fontFamily == null &&
      fontWeight == null &&
      fontStyle == null &&
      fontSize == null &&
      color == null &&
      backgroundColor == null;

  bool get isNotEmpty => !isEmpty;

  bool equalsTo(TextStyle? other) {
    if (other == null) {
      return false;
    }

    return fontFamily == other.fontFamily &&
        fontSize == other.fontSize &&
        fontStyle == other.fontStyle &&
        fontWeight == other.fontWeight &&
        color == other.color &&
        backgroundColor == other.backgroundColor;
  }

  Map<String, dynamic> toMap() => {
        if (fontFamily != null) 'fontFamily': fontFamily,
        if (fontWeight != null) 'fontWeight': fontWeight,
        if (fontSize != null) 'fontSize': fontSize,
        if (fontStyle != null) 'fontStyle': fontStyle,
        if (color != null) 'color': color,
        if (backgroundColor != null) 'backgroundColor': backgroundColor,
      };

  String toPrettyString() => toMap().toPrettyString();
}

class BlockWidget implements Widget {
  const BlockWidget({
    required this.type,
    this.children,
  });

  final List<Widget>? children;
  final String type;

  @override
  Map<String, dynamic> toMap() => {
        'block': type,
        if (children != null)
          'children': children!.map((e) => e.toMap()).toList(),
      };

  @override
  String toPrettyString() => toMap().toPrettyString();
}

class TextWidget implements Widget {
  const TextWidget({
    TextStyle? style,
    this.text,
    this.isLink = false,
    this.children,
  }) : _style = style;

  TextStyle? get style => _style == null || _style!.isEmpty ? null : _style;
  final TextStyle? _style;
  final bool isLink;
  final String? text;
  final List<TextWidget>? children;

  @override
  Map<String, dynamic> toMap() => {
        if (style != null) 'style': style!.toMap(),
        if (text != null) 'text': text,
        if (isLink != false) 'isLink': true,
        if (children != null)
          'children': children!.map((e) => e.toMap()).toList(),
      };

  @override
  String toPrettyString() => toMap().toPrettyString();

  bool hasSameStyleAs(TextWidget other) {
    return style == null ? style == other.style : style!.equalsTo(other.style);
  }
}

String transformType(
  String type, {
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
  }

  return type;
}
