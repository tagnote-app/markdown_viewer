import 'package:dart_markdown/dart_markdown.dart';

extension RoughlyShortenExtensions on Markdown {
  /// Roughly shortens the [markdown] string to the given [length].
  String shorten(String markdown, int length) {
    return _Shorten(
      markdown: markdown,
      maxLength: length,
    ).render(parse(markdown));
  }
}

class _Shorten implements NodeVisitor {
  _Shorten({
    required this.maxLength,
    required this.markdown,
  });

  final int maxLength;
  final String markdown;
  final buffer = StringBuffer();

  var _stopped = false;
  var _position = 0;

  String render(List<Node> nodes) {
    for (final node in nodes) {
      if (_stopped) {
        break;
      }
      node.accept(this);
    }

    final text = buffer.toString();
    if (maxLength >= text.length) {
      return markdown;
    }

    return markdown.substring(0, _position);
  }

  Element? _lastVisitedElement;
  final _parentElements = <Element>[];

  @override
  void visitElementAfter(Element<Node> element) {
    _parentElements.removeLast();
    /*
    if (_stopped) {
      return;
    }
    if (buffer.length >= maxLength) {
      _stopped = true;
      _position = element.end.offset;
    }
    */
  }

  @override
  bool visitElementBefore(Element<Node> element) {
    _parentElements.add(element);
    _lastVisitedElement = element;

    if (_stopped) {
      return false;
    }

    if (buffer.isNotEmpty && element.isBlock) {
      buffer.writeln();
    }
    return true;
  }

  @override
  void visitText(Text text) {
    if (_stopped) {
      return;
    }
    final length = buffer.length;
    buffer.write(text.text);
    if (buffer.length >= maxLength) {
      _stopped = true;
      final parentElement = _parentElements.last;
      if (parentElement.type == 'paragraph') {
        // _position = parentElement.end.offset - ;
        // print(_lastVisitedElement?.textContent);
        // print(_position);
      } else {
        _position = parentElement.end.offset;
      }
    }
  }
}
