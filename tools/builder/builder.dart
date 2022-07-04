import 'package:markdown/markdown.dart';

import 'elements.dart';
import 'style.dart';

class TestCaseBuilder implements NodeVisitor {
  TestCaseBuilder();

  final _tree = <TreeElement>[];
  final _links = <bool>[];
  bool _isInBlockquote = false;

  List<Widget> build(List<Node> nodes) {
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
        _tree.last.children.add(TextWidget(
          text: element.textContent,
        ));
      }
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
      style: generateTextStyle(element, parent.style),
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

    final child = TextWidget(
      text: textContent,
      style: parent.style,
      isLink: _links.isEmpty ? false : _links.removeLast(),
    );

    parent.children.add(child);
  }

  @override
  void visitElementAfter(_) {
    final current = _tree.removeLast();
    final parent = _tree.last;

    if (current.isBlock) {
      Widget blockChild;

      if (current.children.isNotEmpty) {
        blockChild = BlockWidget(
          type: transformType(current.type, level: current.attributes['level']),
          children: _mergeInlines(current.children),
        );
        parent.children.add(blockChild);
      }
    } else {
      parent.children.addAll(current.children);
    }
  }

  /// Merges the [nodes] which are adjacent and have the same types.
  List<Widget> _mergeInlines(List<Widget> widgets) {
    if (widgets.isEmpty) {
      return widgets;
    }
    final result = <Widget>[widgets.first];

    for (var i = 1; i < widgets.length; i++) {
      final current = widgets[i];
      final last = result.last;

      if (current is TextWidget &&
          last is TextWidget &&
          !current.isLink &&
          !last.isLink &&
          current.hasSameStyleAs(last)) {
        final merged = TextWidget(
          text: '${last.text}${current.text}',
          style: current.style,
        );
        result
          ..removeLast()
          ..add(merged);
      } else {
        result.add(current);
      }
    }

    return result;
  }
}
