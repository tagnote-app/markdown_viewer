import 'package:markdown/markdown.dart';

import 'tree_element.dart';

class TestCaseBuilder implements NodeVisitor {
  TestCaseBuilder();

  final _tree = <TreeElement>[];
  final _links = <bool>[];
  bool _isInBlockquote = false;

  List<TextSpan> build(List<Node> nodes) {
    _tree.clear();
    _tree.add(TreeElement.root());
    _isInBlockquote = false;

    for (final node in nodes) {
      assert(_tree.length == 1);
      node.accept(this);
    }

    assert(!_isInBlockquote);
    return _tree.single.children;
  }

  @override
  bool visitElementBefore(Element element) {
    if ([
      'linkReferenceDefinition',
    ].contains(element.type)) {
      return false;
    }

    if (element.type == 'link') {
      _links.add(true);
    } else if (element.type == 'blockquote') {
      _isInBlockquote = true;
    }

    _tree.add(TreeElement.fromAstElement(element, _tree.last));

    return true;
  }

  @override
  void visitText(Text text) {
    final parent = _tree.last;
    var textContent = text.textContent;

    if (!_isInBlockquote) {
      textContent = textContent.replaceAll('\n', ' ');
    }

    parent.children.add({
      'type': parent.isBlock ? 'text' : parent.type,
      'text': textContent,
      if (_links.isNotEmpty) "isLink": _links.removeLast(),
    });
  }

  @override
  void visitElementAfter(_) {
    final current = _tree.removeLast();
    final parent = _tree.last;

    if (current.isBlock) {
      parent.children.add({
        'type': current.type,
        if (current.children.isNotEmpty)
          'children': _mergeInlines(current.children)
      });
    } else {
      parent.children.addAll(current.children);
    }
  }

  /// Merges the [textSpans] which are adjacent and have the same attributes.
  List<TextSpan> _mergeInlines(List<TextSpan> textSpans) {
    final result = <TextSpan>[];

    for (final textSpan in textSpans) {
      if (result.isEmpty) {
        result.add(textSpan);
      } else {
        final last = result.last;
        if (last['type'] == textSpan['type']) {
          result.last['text'] = '${result.last['text']}${textSpan['text']}';
        } else {
          result.add(textSpan);
        }
      }
    }
    return result;
  }
}
