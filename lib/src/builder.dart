import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'helpers.dart';

import 'style.dart';
import 'tree_element.dart';

class MarkdownBuilder implements md.NodeVisitor {
  MarkdownBuilder({
    required MarkdownStyle styleSheet,
    MarkdownTapLinkCallback? onTapLink,
    MarkdownListItemMarkerBuilder? listItemMarkerBuilder,
    MarkdownCheckboxBuilder? checkboxBuilder,
    this.selectable = false,
  })  : _styleSheet = styleSheet,
        _onTapLink = onTapLink,
        _listItemMarkerBuilder = listItemMarkerBuilder,
        _checkboxBuilder = checkboxBuilder;

  final bool selectable;

  final _tree = <TreeElement>[];

  final _listStrack = <String>[];

  bool _isInBlockquote = false;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? _onTapLink;

  final MarkdownListItemMarkerBuilder? _listItemMarkerBuilder;

  final MarkdownCheckboxBuilder? _checkboxBuilder;

  final MarkdownStyle _styleSheet;

  final _linkHandlers = <GestureRecognizer>[];

  List<Widget> build(List<md.Node> nodes) {
    _tree.clear();
    _listStrack.clear();
    _linkHandlers.clear();

    _tree.add(TreeElement.root());
    _isInBlockquote = false;

    for (final md.Node node in nodes) {
      assert(_tree.length == 1);
      node.accept(this);
    }

    assert(!_isInBlockquote);
    return _tree.single.children;
  }

  @override
  bool visitElementBefore(md.Element element) {
    final type = element.type;

    if ([
      'blankLine',
      'linkReferenceDefinition',
      'backslashEscape',
    ].contains(type)) {
      if (type == 'backslashEscape') {
        visitText(element.children.first as md.Text);
      }
      return false;
    }

    final parent = _tree.last;

    if (isListElement(type)) {
      _listStrack.add(type);
    } else if (type == 'blockquote') {
      _isInBlockquote = true;
    } else if (isLinkElement(type) && _onTapLink != null) {
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
    var textContent = text.textContent;
    if (!_isInBlockquote) {
      textContent = trimText(text.textContent);
    }

    final child = _buildRichText(
      TextSpan(
        text: textContent,
        style: parent.style,
        recognizer: _linkHandlers.isEmpty ? null : _linkHandlers.last,
      ),
    );

    parent.children.add(child);
  }

  @override
  void visitElementAfter(md.Element element) {
    final current = _tree.removeLast();
    final type = current.type;
    final parent = _tree.last;

    if (current.isBlock) {
      Widget blockChild;

      if (current.children.isNotEmpty) {
        blockChild = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: mergeInlineChildren(
            current.children,
            richTextBuilder: (span) => _buildRichText(span),
          ),
        );
      } else {
        blockChild = const SizedBox.shrink();
      }

      if (type == 'thematicBreak') {
        blockChild = Container(
          decoration: _styleSheet.horizontalRuleDecoration,
        );
      } else if (isListElement(type)) {
        assert(_listStrack.isNotEmpty);
        _listStrack.removeLast();
      } else if (type == 'listItem' && _listStrack.isNotEmpty) {
        final itemMarker = current.attributes['taskListItem'] == null
            ? _buildListItemMarker(
                _listStrack.last,
                current.attributes['number'],
              )
            : _buildCheckbox(
                current.attributes['taskListItem'] == 'checked',
              );

        blockChild = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: _styleSheet.listItemMinIndent,
              ),
              child: itemMarker,
            ),
            Expanded(child: blockChild),
          ],
        );
      } else if (type == 'blockquote') {
        _isInBlockquote = false;

        blockChild = DecoratedBox(
          decoration: _styleSheet.blockquoteDecoration,
          child: Padding(
            padding: _styleSheet.blockquotePadding,
            child: blockChild,
          ),
        );
      } else if (isLinkElement(type)) {
        _linkHandlers.removeLast();
      }

      if (parent.children.isNotEmpty) {
        parent.children.add(SizedBox(height: _styleSheet.blockSpacing));
      }
      parent.children.add(blockChild);
    } else {
      if (type == 'hardLineBreak') {
        current.children.add(_buildRichText(TextSpan(
          text: '\n',
          style: parent.style,
        )));
      }

      parent.children.addAll(current.children);
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

  Widget _buildListItemMarker(String type, String? number) {
    final listType =
        type == 'bulletList' ? ListType.unordered : ListType.ordered;

    final padding = _styleSheet.listItemMarkerPadding;
    if (_listItemMarkerBuilder != null) {
      return Padding(
        padding: padding,
        child: _listItemMarkerBuilder!(listType, number),
      );
    }

    return Padding(
      padding: padding,
      child: Text(
        listType == ListType.unordered ? '•' : '$number.',
        textAlign: TextAlign.right,
        style: _styleSheet.listItemMarker,
      ),
    );
  }

  Widget _buildCheckbox(bool checked) {
    if (_checkboxBuilder != null) {
      return _checkboxBuilder!(checked);
    }

    return Padding(
      padding: _styleSheet.listItemMarkerPadding,
      child: Icon(
        checked ? Icons.check_box : Icons.check_box_outline_blank,
        size: _styleSheet.checkbox.fontSize,
        color: _styleSheet.checkbox.color,
      ),
    );
  }
}

/// Callback when the user taps a link.
typedef MarkdownTapLinkCallback = void Function(
    String text, String? href, String? title);

typedef MarkdownListItemMarkerBuilder = Widget Function(
    ListType style, String? number);

typedef MarkdownCheckboxBuilder = Widget Function(bool checked);

enum ListType { ordered, unordered }
