import 'package:flutter/material.dart';

import '../definition.dart';
import 'builder.dart';

class ListBuilder extends MarkdownElementBuilder {
  ListBuilder({
    TextStyle? list,
    TextStyle? listItem,
    this.listItemMarker,
    required this.listItemMarkerPadding,
    required this.listItemMinIndent,
    this.checkbox,
    this.listItemMarkerBuilder,
    this.checkboxBuilder,
  }) : super(textStyleMap: {
          'orderedList': list,
          'bulletList': list,
          'listItem': listItem,
        });

  final TextStyle? listItemMarker;
  final TextStyle? checkbox;
  final EdgeInsets listItemMarkerPadding;
  final double listItemMinIndent;
  final MarkdownListItemMarkerBuilder? listItemMarkerBuilder;
  final MarkdownCheckboxBuilder? checkboxBuilder;

  final listStack = <Widget>[];

  final _listStrack = <String>[];

  bool _isList(String type) => type == 'orderedList' || type == 'bulletList';

  @override
  void init(type, attributes) {
    if (_isList(type)) {
      _listStrack.add(type);
    }
  }

  @override
  Widget? buildWidget(element) {
    final type = element.type;
    final child = super.buildWidget(element);
    if (_isList(type)) {
      _listStrack.removeLast();
      return child;
    }

    final itemMarker = element.attributes['taskListItem'] == null
        ? _buildListItemMarker(
            _listStrack.last,
            element.attributes['number'],
          )
        : _buildCheckbox(
            element.attributes['taskListItem'] == 'checked',
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: listItemMinIndent,
          ),
          child: itemMarker,
        ),
        if (child != null) Expanded(child: child),
      ],
    );
  }

  Widget _buildListItemMarker(String type, String? number) {
    final listType = type == 'bulletList'
        ? MarkdownListType.unordered
        : MarkdownListType.ordered;

    final padding = listItemMarkerPadding;
    if (listItemMarkerBuilder != null) {
      return Padding(
        padding: padding,
        child: listItemMarkerBuilder!(listType, number),
      );
    }

    return Padding(
      padding: padding,
      child: Text(
        listType == MarkdownListType.unordered ? '•' : '$number.',
        textAlign: TextAlign.right,
        style: listItemMarker,
      ),
    );
  }

  Widget _buildCheckbox(bool checked) {
    if (checkboxBuilder != null) {
      return checkboxBuilder!(checked);
    }

    final checkboxStyle = const TextStyle(
      fontSize: 18.0,
    ).merge(checkbox);

    return Padding(
      padding: listItemMarkerPadding,
      child: Icon(
        checked ? Icons.check_box : Icons.check_box_outline_blank,
        size: checkboxStyle.fontSize,
        color: checkboxStyle.color,
      ),
    );
  }

  @override
  final matchTypes = ['orderedList', 'bulletList', 'listItem'];
}
