import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart';
import 'package:markdown_viewer/markdown_viewer.dart';
import 'package:markdown_viewer/src/extensions.dart';
import 'theme_data.dart';

void main() {
  // _testDirectory('common_mark');
  _testDirectory('original');
  _testDirectory('gfm');
}

// TODO(Zhiguang): compare the built result with the html result to verify.

void _testDirectory(String name) {
  final directory = '${_getRoot()}/$name';
  final entries = Directory(directory).listSync(
    recursive: true,
    followLinks: false,
  );

  for (final entry in entries) {
    if (name == 'gfm' &&
        ![
          'atx_headings.json',
          'setext_headings.json',
          'emphasis_and_strong_emphasis.json',
          'paragraphs.json',
          'block_quotes.json',
          'fenced_code_blocks.json',
          'indented_code_blocks.json',
          'autolinks.json',
          'autolinks_extension_.json',
          'backslash_escapes.json',
          'blank_lines.json',
          'code_spans.json',
          'disallowed_raw_html_extension_.json',
          'entity_and_numeric_character_references.json',
          'hard_line_breaks.json',
          'html_blocks.json',
          'images.json',
          'inlines.json',
          'link_reference_definitions.json',
          'links.json',
          'list_items.json',
          'lists.json',
          'precedence.json',
          'raw_html.json',
          'soft_line_breaks.json',
          'strikethrough_extension_.json',
          'tables_extension_.json',
          'tabs.json',
          'textual_content.json',
          'thematic_breaks.json',
        ].contains(entry.path.split('/').last)) {
      continue;
    }

    _testFile(entry.path);
  }
}

void _testFile(String path) {
  final json = File(path).readAsStringSync();
  final mapList = List<Map<String, dynamic>>.from(jsonDecode(json));
  for (final testCase in mapList) {
    final expected = testCase['expected'];
    final description = testCase['description'];
    final data = testCase['markdown'];

    //if (!['360', '378'].contains(description.split('-').last)) {
    // continue;
    //}

    if (expected.isEmpty) {
      continue;
    }

    test(description, () {
      final nodes = Document().parseLines(data);
      final actual = MarkdownBuilder(
        styleSheet: MarkdownStyle.fromTheme(themeData),
        onTapLink: (_, __, ___) {},
      ).build(nodes).map((e) => e.toMap()).toList();

      expect(actual, expected);
    });
  }
}

/// Markdown test folder.
String _getRoot() {
  final root = File(Platform.script.path).parent.path;
  return '$root/test';
}
