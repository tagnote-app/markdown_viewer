import 'dart:convert';

import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Map<String, dynamic> toMap() {
    final type = runtimeType;
    final self = this;
    final Map<String, dynamic> map = {
      'type': type.toString(),
    };

    if (self is Column || self is Wrap) {
      map.addAll({
        if ((self as MultiChildRenderObjectWidget).children.isNotEmpty)
          'children': self.children.map((e) => e.toMap()).toList(),
      });
    } else if (self is RichText) {
      final text =
          (self.text is TextSpan) ? (self.text as TextSpan).toMap() : null;

      final children = self.children.map((e) => e.toMap()).toList();
      map.addAll({
        if (children.isNotEmpty) 'children': children,
        if (text != null) 'text': text,
      });
    } else if (self is SizedBox) {
      map.addAll({
        if (self.height != null) 'height': self.height,
        if (self.width != null) 'width': self.width,
      });
    } else if (self is SingleChildRenderObjectWidget) {
      map.addAll({
        if (self.child != null) 'child': self.child?.toMap(),
      });
    } else if (self is Text) {
      map.addAll({
        'data': self.data,
      });
    } else if (self is Expanded) {
      map.addAll({
        'child': self.child.toMap(),
      });
    }
    return map;
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension TextSpanExtensions on TextSpan {
  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      if (text != null) 'text': text,
      if (style != null) 'style': style!.toMap(),
      if (children != null && children!.isNotEmpty)
        'children': children!.map((e) => (e as TextSpan).toMap()).toList()
    };
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension TextStyleExtensions on TextStyle {
  Map<String, dynamic> toMap() => {
        if (fontFamily != null) 'fontFamily': fontFamily,
        if (fontWeight != null) 'fontWeight': fontWeight.toString(),
        if (fontSize != null) 'fontSize': fontSize,
        if (fontStyle != null) 'fontStyle': fontStyle.toString(),
        if (color != null) 'color': color.toString(),
        if (backgroundColor != null)
          'backgroundColor': backgroundColor.toString(),
      };

  String toPrettyString() => toMap().toPrettyString();
}

extension WidgetsExtensions on List<Widget> {
  List<Map<String, dynamic>> toMap() => map((e) => e.toMap()).toList();

  String toPrettyString() => toMap().toPrettyString();
}

extension MapExtensions on Map {
  String toPrettyString() {
    return _toPrettyString(this);
  }
}

extension MapsExtensions on List<Map<String, dynamic>> {
  String toPrettyString() {
    return _toPrettyString(this);
  }
}

String _toPrettyString(Object object) =>
    const JsonEncoder.withIndent("  ").convert(object);
