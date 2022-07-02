import 'package:flutter/material.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarkdownViewer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const markdown = r'''
    var m = 2;
''';

    return Scaffold(
      appBar: AppBar(title: const Text('MarkdownViewer Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: MarkdownViewer(
          markdown,
          onTapLink: (text, href, title) {
            print({text, href, title});
          },
          styleSheet: MarkdownStyle.fromTheme(Theme.of(context)),
        ),
      ),
    );
  }
}
