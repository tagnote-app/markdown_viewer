import 'dart:convert';

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
