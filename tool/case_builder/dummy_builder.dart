import 'package:dart_markdown/dart_markdown.dart';

class MarkdownRenderer {
  MarkdownRenderer({
    required this.styleSheet,
    MarkdownTapLinkCallback? onTapLink,
  });

  final MarkdownStyle styleSheet;

  List<Widget> render(List<Node> nodes) {
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

typedef MarkdownTapLinkCallback = void Function(String? href, String? title);
