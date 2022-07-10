import 'package:flutter/material.dart';

import '../definition.dart';
import 'builder.dart';

class TableBuilder extends MarkdownElementBuilder {
  TableBuilder({
    TextStyle? table,
    TextStyle? tableHead,
    required this.tableBody,
    required this.tableCellPadding,
    required this.tableColumnWidth,
    this.tableBorder,
    this.tableHeadCellAlign,
    this.tableRowDecoration,
    this.tableRowDecorationAlternating,
  }) : super(textStyleMap: {
          'table': table,
          'tableHead': tableHead,
        });

  final TextStyle tableBody;
  final EdgeInsets tableCellPadding;
  final TableBorder? tableBorder;
  final TableColumnWidth tableColumnWidth;
  final TextAlign? tableHeadCellAlign;
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
  void before(type, attributes) {
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
  void after(renderer, element) {
    final type = element.type;

    if (type == 'table') {
      renderer.writeBlock(Table(
        defaultColumnWidth: tableColumnWidth,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: tableBorder,
        children: _tableStack.removeLast().rows,
      ));
    } else if (type == 'tableHeadCell' || type == 'tableBodyCell') {
      final children = element.children;
      TextAlign? textAlign;
      if (type == 'tableHeadCell') {
        textAlign = tableHeadCellAlign;
      }

      textAlign ??= {
        'left': TextAlign.left,
        'right': TextAlign.right,
        'center': TextAlign.center,
      }[element.attributes['textAlign']];

      _tableStack.single.rows.last.children!.add(
        TableCell(
          child: Padding(
            padding: tableCellPadding,
            child: DefaultTextStyle(
              style: tableBody,
              textAlign: textAlign,
              child: children.single,
            ),
          ),
        ),
      );
    }
  }
}

class _TableElement {
  final List<TableRow> rows = <TableRow>[];
}
