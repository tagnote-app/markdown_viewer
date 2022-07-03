import 'package:markdown/markdown.dart';

import 'tree_element.dart';

class TestCaseBuilder implements NodeVisitor {
  TestCaseBuilder();

  final _tree = <TreeElement>[];
  final _links = <bool>[];
  bool _isInBlockquote = false;

  List<Map<String, dynamic>> build(List<Node> nodes) {
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
      'backslashEscape',
    ].contains(element.type)) {
      if (element.type == 'backslashEscape') {
        _tree.last.children.add({
          'text': element.textContent,
        });
      }
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
      'text': textContent,
    });
  }

  @override
  void visitElementAfter(_) {
    final current = _tree.removeLast();
    final parent = _tree.last;

    parent.children.add({
      (current.isBlock ? 'block' : 'inline'): current.type,
      if (current.children.isNotEmpty)
        'children': _mergeInlines(current.children),
    });
  }

  /// Merges the [nodes] which are adjacent and have the same types.
  List<Map<String, dynamic>> _mergeInlines(List<Map<String, dynamic>> nodes) {
    final result = <Map<String, dynamic>>[];

    for (final node in nodes) {
      if (result.isEmpty) {
        result.add(node);
      } else {
        final last = result.last;

        if (node['inline'] != null &&
            node['inline'] != 'link' &&
            last['inline'] == node['inline']) {
          (result.last['children'] as List).add(node);
        } else if (last['text'] != null && node['text'] != null) {
          result.last['text'] = '${result.last['text']}${node['text']}';
        } else {
          result.add(node);
        }
      }
    }

    return result;
  }
}

// List<Map<String, dynamic>> _mergeText(List<Map<String, dynamic>> nodes) {}
