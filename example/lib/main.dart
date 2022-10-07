// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

import 'extension.dart';

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
    const markdown = r'''
Hello **Markdown**!

---
#example
''';

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
          selectionColor: Colors.blue.withAlpha(80),
          syntaxExtensions: [ExampleSyntax()],
          onTapLink: (href, title) {
            print({href, title});
          },
          elementBuilders: [
            ExampleBuilder(),
          ],
        ),
      ),
    );
  }
}
