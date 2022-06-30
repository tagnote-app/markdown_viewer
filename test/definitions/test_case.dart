import 'package:flutter/material.dart';

class TestCase {
  const TestCase({
    required this.description,
    required this.markdown,
    required this.textSpans,
  });

  factory TestCase.formJson(Map<String, dynamic> json) {
    final textSpans = List<Map<String, dynamic>>.from(json['textSpans'])
        .map((item) => TestCaseTextSpan.formJson(item))
        .toList();

    return TestCase(
      description: json['description'],
      markdown: json['markdown'],
      textSpans: textSpans,
    );
  }

  final String description;
  final String markdown;
  final List<TestCaseTextSpan> textSpans;
}

class TestCaseTextSpan {
  const TestCaseTextSpan({
    required this.fontStyle,
    required this.fontWeight,
    required this.fontFamily,
    required this.text,
    required this.color,
    required this.isLink,
  });

  factory TestCaseTextSpan.formJson(Map<String, dynamic> json) {
    return TestCaseTextSpan(
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

  Map<String, dynamic> toMap() => {
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
