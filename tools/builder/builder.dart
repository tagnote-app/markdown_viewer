import 'package:markdown/markdown.dart';

import 'helpers.dart';
import 'styles.dart';
import 'tree_element.dart';

class TestCaseBuilder implements NodeVisitor {
  TestCaseBuilder();

  final _tree = <TreeElement>[];
  final _links = <bool>[];

  List<TextSpan> build(List<Node> nodes) {
    _tree.clear();
    _tree.add(TreeElement.root());

    for (final node in nodes) {
      assert(_tree.length == 1);
      node.accept(this);
    }

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
    parent.children.add({
      'text': formatText(text.textContent),
      ...parent.style,
      if (_links.isNotEmpty) "isLink": _links.removeLast(),
    });
  }

  @override
  void visitElementAfter(Element element) {
    final last = _tree.removeLast();
    final parent = _tree.last;
    parent.children.addAll(_mergeTextSpans(last.children));
  }

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
