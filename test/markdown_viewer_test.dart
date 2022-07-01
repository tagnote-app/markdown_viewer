import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

import 'definitions/test_case.dart';
import 'theme_data.dart';

void main() {
  // _testDirectory('common_mark');
  _testDirectory('gfm');
}

void _testDirectory(String name) {
  final directory = '${_getRoot()}/$name';
  final entries = Directory(directory).listSync(
    recursive: true,
    followLinks: false,
  );

  for (final entry in entries) {
    if (![
      'emphasis_and_strong_emphasis.json',
    ].contains(entry.path.split('/').last)) {
      continue;
    }

    _testFile(entry.path);
  }
}

void _testFile(String path) {
  final json = File(path).readAsStringSync();
  final mapList = List<Map<String, dynamic>>.from(jsonDecode(json));
  for (final map in mapList) {
    final testCase = TestCase.formJson(map);
    testWidgets(testCase.description, (WidgetTester tester) async {
      final data = testCase.markdown;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MarkdownViewer(
            data,
            onTapLink: (_, __, ___) {},
            styleSheet: MarkdownStyle.fromTheme(
              themeData,
              link: const TextStyle(color: Color(0xff2196f3)),
            ),
          ),
        ),
      );

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsOneWidget);

      final richText = richTextFinder.evaluate().first.widget as RichText;
      final expectedTextSpans = testCase.textSpans;
      if (expectedTextSpans.isEmpty) {
        return;
      }
      expect(richText, isNotNull);

      List<TextSpan> textSpans;
      if (expectedTextSpans.length == 1) {
        textSpans = [richText.text as TextSpan];
      } else {
        final parentTextSpan = richText.text as TextSpan;

        expect(parentTextSpan, isNotNull);
        expect(
          parentTextSpan.children,
          isNotNull,
        );
        expect(parentTextSpan.children!.length, expectedTextSpans.length);

        textSpans = List<TextSpan>.from(parentTextSpan.children!);
      }

      for (var i = 0; i < textSpans.length; i++) {
        final textSpan = textSpans[i];
        final expectedTextSpan = expectedTextSpans[i];

        expect(textSpan.toPlainText(), expectedTextSpan.text);
        expect(textSpan.style, isNotNull);
        expect(textSpan.style!.fontStyle, expectedTextSpan.fontStyle);
        expect(textSpan.style!.fontWeight, expectedTextSpan.fontWeight);
        expect(textSpan.style!.fontFamily, expectedTextSpan.fontFamily);
        if (textSpan.style!.color != null) {
          expect(textSpan.style!.color.toString(), expectedTextSpan.color);
        }
        if (expectedTextSpan.isLink) {
          expect(textSpan.recognizer, isNotNull);
          expect(textSpan.recognizer is GestureRecognizer, isTrue);
        }
      }
    });
  }
}

/// Markdown test folder.
String _getRoot() {
  final root = File(Platform.script.path).parent.path;
  return '$root/test';
}
