import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'helpers/merge_inline_children.dart';
import 'helpers/tree_element.dart';
import 'helpers/trim_text.dart';
import 'style.dart';

class MarkdownBuilder implements md.NodeVisitor {
  MarkdownBuilder({
    required MarkdownStyle styleSheet,
    MarkdownTapLinkCallback? onTapLink,
    this.selectable = false,
  })  : _styleSheet = styleSheet,
        _onTapLink = onTapLink;

  final bool selectable;

  final _tree = <TreeElement>[];

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? _onTapLink;

  final MarkdownStyle _styleSheet;

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

    if (element.type == 'link' && _onTapLink != null) {
      _addLinkHandler(element);
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

  void _addLinkHandler(md.Element element) {
    _linkHandlers.add(TapGestureRecognizer()
      ..onTap = () {
        _onTapLink!(
          element.textContent,
          element.attributes['destination'],
          element.attributes['title'],
        );
      });
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

/// Callback when the user taps a link.
typedef MarkdownTapLinkCallback = void Function(
    String text, String? href, String? title);
