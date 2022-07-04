import 'package:markdown/markdown.dart';

class MarkdownBuilder {
  MarkdownBuilder({
    required this.styleSheet,
  });

  final MarkdownStyle styleSheet;

  List<Widget> build(List<Node> nodes) {
    return [];
  }
}

class Widget {
  Map<String, dynamic> toMap() => {};
}

class MarkdownStyle {
  MarkdownStyle.fromTheme(ThemeData themeData);
}

class ThemeData {}

final themeData = ThemeData();
