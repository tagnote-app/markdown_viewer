import 'package:flutter/material.dart';

import '../definition.dart';
import 'builder.dart';

class TableBuilder extends MarkdownElementBuilder {
  TableBuilder({
    TextStyle? table,
    TextStyle? tableHead,
    TextStyle? tableBody,
    this.tableBorder,
    this.tableRowDecoration,
    this.tableRowDecorationAlternating,
    required this.tableCellPadding,
    required this.tableColumnWidth,
  }) : super(textStyleMap: {
          'table': table,
          'tableHead': tableHead,
          'tableBody': tableBody,
        });

  final EdgeInsets tableCellPadding;
  final TableBorder? tableBorder;
  final TableColumnWidth tableColumnWidth;
  final BoxDecoration? tableRowDecoration;
  final MarkdownAlternating? tableRowDecorationAlternating;

  final _tableStack = <_TableElement>[];

  @override
  final matchTypes = [
    'table',
    'tableHead',
    'tableRow',
    'tableBody',
    'tableHeadCell',
    'tableBodyCell',
  ];

  @override
  bool isBlock(element) => element.type == 'table';

  @override
  void init(type, attributes) {
    if (type == 'table') {
      _tableStack.add(_TableElement());
    } else if (type == 'tableRow') {
      var decoration = tableRowDecoration;
      final alternating = tableRowDecorationAlternating;
      if (alternating != null) {
        final length = _tableStack.single.rows.length;
        if (alternating == MarkdownAlternating.odd) {
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
    }
  }

  @override
  TextAlign? textAlign(parent) {
    TextAlign? textAlign;
    if (parent.type == 'tableHeadCell' || parent.type == 'tableBodyCell') {
      textAlign = {
        'left': TextAlign.left,
        'right': TextAlign.right,
        'center': TextAlign.center,
      }[parent.attributes['textAlign']];
    }
    return textAlign;
  }

  @override
  Widget? buildWidget(element) {
    final type = element.type;

    if (type == 'table') {
      return Table(
        defaultColumnWidth: tableColumnWidth,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: tableBorder,
        children: _tableStack.removeLast().rows,
      );
    } else if (type == 'tableHeadCell' || type == 'tableBodyCell') {
      final children = element.children;

      _tableStack.single.rows.last.children!.add(
        TableCell(
          child: Padding(
            padding: tableCellPadding,
            child: children.isEmpty ? const SizedBox.shrink() : children.single,
          ),
        ),
      );
    }

    return null;
  }
}

class _TableElement {
  final List<TableRow> rows = <TableRow>[];
}
