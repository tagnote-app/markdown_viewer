import 'package:markdown/markdown.dart';

import 'styles.dart';
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
    final parent = _tree.last;

    if (element.type == 'link') {
      _links.add(true);
    } else if (element.type == 'blockquote') {
      _isInBlockquote = true;
    }

    _tree.add(TreeElement.fromAstElement(
      element,
      style: generateStyle(element, parent.style),
    ));

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
      'type': 'TextSpan',
      'text': textContent,
      ...parent.style,
      if (_links.isNotEmpty) "isLink": _links.removeLast(),
    });
  }

  @override
  void visitElementAfter(Element element) {
    final current = _tree.removeLast();
    final parent = _tree.last;

    if (current.isBlock) {
      Map<String, dynamic> blockChild;

      if (current.children.isNotEmpty) {
        blockChild = {
          'type': 'Column',
          'children': _mergeTextSpans(current.children),
        };
      } else {
        blockChild = {
          'type': 'SizedBox',
        };
      }

      if (current.type == 'blockquote') {
        _isInBlockquote = false;
        blockChild = {
          'type': 'DecoratedBox',
          'child': {
            'type': 'Padding',
            'child': blockChild,
          }
        };
      }

      parent.children.add(blockChild);
    } else {
      parent.children.addAll(current.children);
    }
  }

  /// Merges the [textSpans] which are adjacent and have the same attributes.
  List<TextSpan> _mergeTextSpans(List<TextSpan> textSpans) {
    final result = <TextSpan>[];

    for (final textSpan in textSpans) {
      if (result.isEmpty) {
        result.add(textSpan);
      } else {
        final last = result.last;
        if (haveSameAttributes(last, textSpan)) {
          result.last['text'] = '${result.last['text']}${textSpan['text']}';
        } else {
          result.add(textSpan);
        }
      }
    }
    return result;
  }
}
