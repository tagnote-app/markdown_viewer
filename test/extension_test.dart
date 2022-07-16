// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_viewer/markdown_viewer.dart';
import 'package:markdown_viewer/src/extensions.dart';
import '../example/lib/extension.dart';

void main() {
  testWidgets('extension', ((tester) async {
    const data = '''
Hello **Markdown**!

---
#example
''';

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MarkdownViewer(
          data,
          syntaxExtensions: [ExampleSyntax()],
          elementBuilders: [
            ExampleBuilder(),
          ],
        ),
      ),
    );

    final allWidgets = tester.allWidgets;
    expect(allWidgets.elementAt(2).toMap(), {
      'type': 'Column',
      'children': [
        {
          'type': 'Column',
          'children': [
            {
              'type': 'RichText',
              'textAlign': 'TextAlign.start',
              'text': {
                'type': 'TextSpan',
                'children': [
                  {
                    'type': 'TextSpan',
                    'text': 'Hello ',
                    'style': {
                      'fontFamily': 'Roboto',
                      'fontWeight': 'FontWeight.w400',
                      'fontSize': 14.0,
                      'color': 'Color(0xdd000000)'
                    }
                  },
                  {
                    'type': 'TextSpan',
                    'text': 'Markdown',
                    'style': {
                      'fontFamily': 'Roboto',
                      'fontWeight': 'FontWeight.w700',
                      'fontSize': 14.0,
                      'color': 'Color(0xdd000000)'
                    }
                  },
                  {
                    'type': 'TextSpan',
                    'text': '!',
                    'style': {
                      'fontFamily': 'Roboto',
                      'fontWeight': 'FontWeight.w400',
                      'fontSize': 14.0,
                      'color': 'Color(0xdd000000)'
                    }
                  }
                ]
              }
            }
          ]
        },
        {'type': 'SizedBox', 'height': 8.0},
        {'type': 'Divider'},
        {'type': 'SizedBox', 'height': 8.0},
        {
          'type': 'Column',
          'children': [
            {
              'type': 'RichText',
              'textAlign': 'TextAlign.start',
              'text': {
                'type': 'TextSpan',
                'text': 'example',
                'style': {
                  'fontFamily': 'Roboto',
                  'fontWeight': 'FontWeight.w400',
                  'fontSize': 14.0,
                  'color': 'MaterialColor(primary value: Color(0xff4caf50))',
                  'decoration': 'TextDecoration.underline'
                }
              }
            }
          ]
        }
      ]
    });
  }));
}
