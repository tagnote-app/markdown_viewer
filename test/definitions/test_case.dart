import 'package:flutter/material.dart';

class TestCase {
  const TestCase({
    required this.description,
    required this.markdown,
    required this.expected,
  });

  factory TestCase.formJson(Map<String, dynamic> json) {
    final expected = List<Map<String, dynamic>>.from(json['expected'])
        .map((item) => ExpectedBlock.formJson(item))
        .toList();

    return TestCase(
      description: json['description'],
      markdown: json['markdown'],
      expected: expected,
    );
  }

  final String description;
  final String markdown;
  final List<ExpectedElement> expected;
}

abstract class ExpectedElement {
  const ExpectedElement({
    required this.type,
  });

  final String type;

  Map<String, dynamic> toMap();
}

class ExpectedBlock extends ExpectedElement {
  ExpectedBlock({
    required String type,
    required this.children,
  }) : super(type: type);

  factory ExpectedBlock.formJson(Map<String, dynamic> json) {
    return ExpectedBlock(
      type: json['type'],
      children: List<ExpectedElement>.from(
        List<Map<String, dynamic>>.from(json['children']).map(
          (e) => e['type'] == 'TextSpan'
              ? ExpectedInline.formJson(e)
              : ExpectedBlock.formJson(e),
        ),
      ),
    );
  }

  List<ExpectedElement> children;

  @override
  Map<String, dynamic> toMap() => {
        'type': type,
        'children': children.map((e) => e.toMap()).toList(),
      };
}

class ExpectedInline extends ExpectedElement {
  const ExpectedInline({
    required String type,
    required this.fontStyle,
    required this.fontWeight,
    required this.fontFamily,
    required this.text,
    required this.color,
    required this.isLink,
  }) : super(type: type);

  factory ExpectedInline.formJson(Map<String, dynamic> json) {
    return ExpectedInline(
      type: json['type'],
      fontStyle: _fontStyleFromString(json['fontStyle']),
      fontWeight: _fontWeightFromInt(json['fontWeight']),
      fontFamily: json['fontFamily'],
      color: json['color'],
      isLink: json['isLink'] == true,
      text: json['text'],
    );
  }

  final FontStyle? fontStyle;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final String? color;
  final String text;
  final bool isLink;

  @override
  Map<String, dynamic> toMap() => {
        'type': type,
        'text': text,
        'fontStyle': fontStyle,
        'fontWeight': fontWeight,
        'fontFamily': fontFamily,
      };
}

FontStyle? _fontStyleFromString(String? value) => value == null
    ? null
    : FontStyle.values.firstWhere((e) => e.toString().split('.').last == value);

FontWeight? _fontWeightFromInt(int? value) => {
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w400,
      500: FontWeight.w500,
      600: FontWeight.w600,
      700: FontWeight.w700,
      800: FontWeight.w800,
      900: FontWeight.w900,
    }[value];
