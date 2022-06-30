part of 'extensions.dart';

extension WidgetExtensions on Widget {
  Map<String, dynamic> toMap() {
    final type = runtimeType.toString();
    final self = this;

    if (self is MultiChildRenderObjectWidget) {
      Map<String, dynamic>? spanChild;
      if (self is RichText) {
        final text = self.text;
        if (text is TextSpan) {
          spanChild = text.toMap();
        }
      }

      final children = [];

      for (final item in self.children) {
        children.add(item.toMap());
      }

      return {
        'type': type,
        if (children.isNotEmpty) 'children': children,
        if (spanChild != null) 'span': spanChild,
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
