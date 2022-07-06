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
    MarkdownHighlightBuilder? highlightBuilder,
    this.selectable = false,
  })  : _styleSheet = styleSheet,
        _onTapLink = onTapLink,
        _listItemMarkerBuilder = listItemMarkerBuilder,
        _highlightBuilder = highlightBuilder,
        _checkboxBuilder = checkboxBuilder;

  final bool selectable;

  final _tree = <TreeElement>[];

  final _listStrack = <String>[];

  final _tableStack = <_TableElement>[];

  bool _isInBlockquote = false;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? _onTapLink;

  final MarkdownListItemMarkerBuilder? _listItemMarkerBuilder;

  final MarkdownCheckboxBuilder? _checkboxBuilder;

  final MarkdownHighlightBuilder? _highlightBuilder;

  final MarkdownStyle _styleSheet;

  final _linkHandlers = <GestureRecognizer>[];

  List<Widget> build(List<md.Node> nodes) {
    _tree.clear();
    _listStrack.clear();
    _tableStack.clear();
    _linkHandlers.clear();

    _tree.add(TreeElement.root());
    _isInBlockquote = false;

    for (final md.Node node in nodes) {
      assert(_tree.length == 1);
      node.accept(this);
    }

    assert(_tableStack.isEmpty);
    assert(_listStrack.isEmpty);
    // TODO(Zhiguang): enable it
    // assert(_linkHandlers.isEmpty);
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
    } else if (type == 'table') {
      _tableStack.add(_TableElement());
    } else if (type == 'tableRow') {
      var decoration = _styleSheet.tableRowDecoration;
      final alternating = _styleSheet.tableRowDecorationAlternating;
      if (alternating != null) {
        final length = _tableStack.single.rows.length;
        if (alternating == TableRowDecorationAlternating.odd) {
          decoration = length.isOdd ? null : decoration;
        } else {
          decoration = length.isOdd ? decoration : null;
        }
      }

      _tableStack.single.rows.add(TableRow(
        decoration: decoration,
        // TODO(Zhiguang) Fix it.
        children: [],
      ));
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

    Widget child;
    if (isCodeBlockElement(parent.type)) {
      child = Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: _styleSheet.codeblockPadding,
          child: _buildRichText(
            _highlightBuilder == null
                ? TextSpan(
                    text: text.text.trimRight(),
                    style: parent.style,
                  )
                : _highlightBuilder!(text.text, parent.attributes['language'],
                    parent.attributes['infoString']),
          ),
        ),
      );
    } else {
      if (!_isInBlockquote) {
        textContent = trimText(text.textContent);
      }

      child = _buildRichText(
        TextSpan(
          text: textContent,
          style: parent.style,
          recognizer: _linkHandlers.isEmpty ? null : _linkHandlers.last,
        ),
      );
    }

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
          children: _mergeInlineChildren(current.children),
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
      } else if (type == 'table') {
        blockChild = Table(
          defaultColumnWidth: _styleSheet.tableColumnWidth,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _styleSheet.tableBorder,
          children: _tableStack.removeLast().rows,
        );
      } else if (isCodeBlockElement(type)) {
        blockChild = DecoratedBox(
          decoration: _styleSheet.codeblockDecoration,
          child: blockChild,
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
      } else if (type == 'tableHeadCell' || type == 'tableBodyCell') {
        TextAlign? textAlign;
        if (type == 'tableHeadCell') {
          textAlign = _styleSheet.tableHeadCellAlign;
        }

        textAlign ??= {
          'left': TextAlign.left,
          'right': TextAlign.right,
          'center': TextAlign.center,
        }[current.attributes['textAlign']];

        _tableStack.single.rows.last.children!.add(
          _buildTableCell(current.children, textAlign: textAlign),
        );
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

  Widget _buildTableCell(List<Widget> children, {TextAlign? textAlign}) {
    children = _mergeInlineChildren(children, textAlign);

    return TableCell(
      child: Padding(
        padding: _styleSheet.tableCellPadding,
        child: DefaultTextStyle(
          style: _styleSheet.tableBody,
          // TODO(Zhiguang): the textAlign does not work, it works if remove
          // Wrap
          textAlign: textAlign,
          // TODO(Zhiguang): It is fine to only remove Wrap here, but try to
          // remove all the Wraps on top of RichText.
          child:
              children.length == 1 ? children.single : Wrap(children: children),
        ),
      ),
    );
  }

  List<Widget> _mergeInlineChildren(
    List<Widget> children, [
    TextAlign? textAlign,
  ]) =>
      mergeInlineChildren(
        children,
        richTextBuilder: (span) => _buildRichText(span, textAlign: textAlign),
      );
}

/// Callback when the user taps a link.
typedef MarkdownTapLinkCallback = void Function(
    String text, String? href, String? title);

typedef MarkdownListItemMarkerBuilder = Widget Function(
    ListType style, String? number);

typedef MarkdownCheckboxBuilder = Widget Function(bool checked);

typedef MarkdownHighlightBuilder = TextSpan Function(
    String text, String? language, String? infoString);

enum ListType { ordered, unordered }

class _TableElement {
  final List<TableRow> rows = <TableRow>[];
}
