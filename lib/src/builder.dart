import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'helpers/create_link.dart';
import 'helpers/merge_inline_children.dart';
import 'helpers/trim_text.dart';
import 'style_sheet.dart';
import 'tree_element.dart';

class MarkdownBuilder implements md.NodeVisitor {
  MarkdownBuilder({
    MarkdownStyleSheet? styleSheet,
    this.selectable = false,
  }) : _styleSheet = styleSheet ?? MarkdownStyleSheet();

  final bool selectable;

  final _tree = <TreeElement>[];

  final MarkdownStyleSheet _styleSheet;

  final _linkHandlers = <GestureRecognizer>[];

  List<Widget> build(List<md.Node> nodes) {
    _tree.clear();
    _tree.add(TreeElement.root());

    for (final md.Node node in nodes) {
      assert(_tree.length == 1);
      node.accept(this);
    }

    return _tree.single.children;
  }

  @override
  bool visitElementBefore(md.Element element) {
    final parent = _tree.last;

    if (element.type == 'link') {
      _linkHandlers.add(createLink(element));
    }

    _tree.add(TreeElement.fromAstElement(
      element,
      style: _styleSheet.style(element, parent.style),
    ));

    return true;
  }

  @override
  void visitText(md.Text text) {
    final parent = _tree.last;

    final child = _buildRichText(
      TextSpan(
        text: trimText(text.textContent),
        style: parent.style,
        recognizer: _linkHandlers.isEmpty ? null : _linkHandlers.removeLast(),
      ),
    );

    parent.children.add(child);
  }

  @override
  void visitElementAfter(md.Element element) {
    final last = _tree.removeLast();
    final parent = _tree.last;

    if (last.isBlock) {
      parent.children.add(Wrap(
        children: mergeInlineChildren(
          last.children,
          richTextBuilder: _buildRichText,
        ),
      ));
    } else {
      parent.children.addAll(last.children);
    }
  }

  Widget _buildRichText(TextSpan? text, {TextAlign? textAlign}) {
    if (selectable) {
      return SelectableText.rich(
        text!,
        textAlign: textAlign ?? TextAlign.start,
        onTap: () {},
      );
    } else {
      return RichText(
        text: text!,
        textAlign: textAlign ?? TextAlign.start,
      );
    }
  }
}
