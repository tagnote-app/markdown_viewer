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
      //'atx_headings.json',
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
    final expected = testCase.expected;
    if (expected.isEmpty) {
      continue;
    }

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

      final rootColumn = tester.firstWidget(find.byType(Column));

      void loopTest(widget, ExpectedElement expectedElement) {
        expect(widget.runtimeType.toString(), expectedElement.type);
        if (widget is Column) {
          expect(expectedElement.runtimeType, ExpectedBlock);

          // First child of a Column should be either a Column or a Wrap.
          final firstChild = widget.children.first;
          final children = [];
          if (firstChild is Column) {
            children.addAll(widget.children);
          } else {
            expect(firstChild.runtimeType, Wrap);
            final wrapChildren = (firstChild as Wrap).children;
            if (wrapChildren.isEmpty) {
              return;
            }
            final richText = wrapChildren.first;
            expect(richText.runtimeType, RichText);

            final textSpan = (richText as RichText).text as TextSpan;
            if (textSpan.children == null) {
              children.add(textSpan);
            } else {
              children.addAll(textSpan.children!);
            }
          }

          for (var i = 0; i < widget.children.length; i++) {
            loopTest(
              children[i],
              (expectedElement as ExpectedBlock).children[i],
            );
          }
        } else if (widget is TextSpan) {
          final expectedTextSpan = expectedElement as ExpectedInline;

          expect(widget.toPlainText(), expectedTextSpan.text);
          expect(widget.style, isNotNull);
          expect(widget.style!.fontStyle, expectedTextSpan.fontStyle);
          expect(widget.style!.fontWeight, expectedTextSpan.fontWeight);
          expect(widget.style!.fontFamily, expectedTextSpan.fontFamily);
          if (widget.style!.color != null) {
            expect(widget.style!.color.toString(), expectedTextSpan.color);
          }
          if (expectedTextSpan.isLink) {
            expect(widget.recognizer, isNotNull);
            expect(widget.recognizer is GestureRecognizer, isTrue);
          }
        }
      }

      loopTest(rootColumn, expected.first);
    });
  }
}

/// Markdown test folder.
String _getRoot() {
  final root = File(Platform.script.path).parent.path;
  return '$root/test';
}
