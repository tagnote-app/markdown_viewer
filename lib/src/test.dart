import 'package:dart_markdown/dart_markdown.dart';
import './shorten.dart';

void main() {
  const text = 'Hello **world**!!!!!';
  print(Markdown().shorten(text, 2));
  print(Markdown().shorten(text, 9));
  print(Markdown().shorten(text, 10));
  print(Markdown().shorten(text, 12));
}
