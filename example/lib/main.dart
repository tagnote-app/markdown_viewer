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
    const markdown = '''
# Heading 1
## Heading 2
Hello **world**!
''';

    return Scaffold(
      appBar: AppBar(title: const Text('MarkdownViewer Demo')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: MarkdownViewer(markdown),
      ),
    );
  }
}
