// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_prism/flutter_prism.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

import 'extension.dart';

const markdown = r'''
## Markdown Viewer

```dart
// Dart language.
void main() {
  print('Hello, World!');
}
```
>>>
''';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MarkdownViewer Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MarkdownViewer Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: MarkdownViewer(
          markdown,
          enableTaskList: true,
          enableSuperscript: false,
          enableSubscript: false,
          enableFootnote: false,
          enableImageSize: false,
          enableKbd: false,
          syntaxExtensions: [ExampleSyntax()],
          highlightBuilder: (text, language, infoString) {
            final prism = Prism(style: PrismStyle());
            return prism.render(text, language ?? 'plain');
          },
          onTapLink: (href, title) {
            print({href, title});
          },
          elementBuilders: [
            ExampleBuilder(),
          ],
          styleSheet: const MarkdownStyle(
            codeBlock: TextStyle(
              letterSpacing: -0.3,
              fontSize: 14,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      ),
    );
  }
}
