part of 'extensions.dart';

extension WidgetExtensions on Widget {
  Map<String, dynamic> toMap() {
    final type = runtimeType.toString();
    final self = this;

    if (self is Column || self is Wrap) {
      return {
        'type': type,
        'children': (self as MultiChildRenderObjectWidget)
            .children
            .map((e) => e.toMap())
            .toList(),
      };
    } else if (self is RichText) {
      Map<String, dynamic>? spanChild;
      final text = self.text;
      if (text is TextSpan) {
        spanChild = text.toMap();
      }

      final children = self.children.map((e) => e.toMap()).toList();
      return {
        'type': type,
        if (children.isNotEmpty) 'children': children,
        if (spanChild != null) 'span': spanChild,
      };
    } else if (self is SingleChildRenderObjectWidget) {
      return {
        'type': type,
        'child': self.child?.toMap(),
      };
    } else if (self is Text) {
      return {
        'type': type,
        'data': self.data,
      };
    } else if (self is Expanded) {
      return {
        'type': type,
        'child': self.child.toMap(),
      };
    } else {
      return {
        'type': type,
      };
    }
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension TextSpanExtensions on TextSpan {
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'type': runtimeType.toString(),
      if (text != null) 'text': text,
    };

    if (children != null && children!.isNotEmpty) {
      final childMaps = <Map<String, dynamic>>[];
      for (final item in children!) {
        if (item is! TextSpan) {
          continue;
        }
        childMaps.add(item.toMap());
      }

      map['children'] = childMaps;
    }

    return map;
  }
}

extension WidgetsExtensions on List<Widget> {
  List<Map<String, dynamic>> toMap() => map((e) => e.toMap()).toList();

  String toPrettyString() => toMap().toPrettyString();
}
