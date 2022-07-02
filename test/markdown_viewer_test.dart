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
      'atx_headings.json',
      'setext_headings.json',
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

      final allWidgets = tester.allWidgets;
      expect(allWidgets.elementAt(0).runtimeType, Directionality);
      expect(allWidgets.elementAt(1).runtimeType, MarkdownViewer);
      expect(allWidgets.elementAt(2).runtimeType, Column);

      final rootColumn = allWidgets.elementAt(2);

      void loopTest(widget, ExpectedElement expectedElement) {
        expect(widget.runtimeType.toString(), expectedElement.type);
        if (widget is Column) {
          expect(expectedElement.runtimeType, ExpectedBlock);

          final children = [];

          // If the first child of current Widget is a Wrap, this Widget has
          // only inline children.
          if (widget.children.first is Wrap) {
            // A Widget could have only one Wrap child.
            expect(widget.children.length, 1);
            final wrapChildren = (widget.children.first as Wrap).children;
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
          } else {
            children.addAll(widget.children);
          }

          for (var i = 0; i < widget.children.length; i++) {
            loopTest(
              children[i],
              (expectedElement as ExpectedBlock).children![i],
            );
          }
        } else if (widget is TextSpan) {
          final expectedTextSpan = expectedElement as ExpectedInline;

          expect(widget.style, isNotNull);
          expect(
            {
              'text': widget.toPlainText(),
              'fontStyle': widget.style!.fontStyle,
              'fontWeight': widget.style!.fontWeight,
              'fontFamily': widget.style!.fontFamily,
              if (widget.style!.color != null)
                'color': widget.style!.color.toString(),
              'isLink': widget.recognizer != null &&
                  widget.recognizer is GestureRecognizer,
            },
            expectedTextSpan.toMap()..remove('type'),
          );
        }
        // If current widget has no child.
        else if (widget is SizedBox) {
          expect({
            'height': widget.height,
            'width': widget.width,
          }, {
            'height': 0.0,
            'width': 0.0,
          });
        }
      }

      // The root Column is the Column from MarkdownBuilder if the built result
      // has only one Column, otherwise the root Column is the Column from
      // MarkdownViwer widget, so it needs to add one more layer on top of
      // expected.
      loopTest(
          rootColumn,
          expected.length == 1
              ? expected.single
              : ExpectedBlock(type: 'Column', children: expected));
    });
  }
}

/// Markdown test folder.
String _getRoot() {
  final root = File(Platform.script.path).parent.path;
  return '$root/test';
}
