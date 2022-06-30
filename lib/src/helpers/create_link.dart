import 'package:flutter/gestures.dart';
import 'package:markdown/markdown.dart' as md;

GestureRecognizer createLink(md.Element element) {
  // TODO(Zhiguagn): link.
  return TapGestureRecognizer()
    ..onTap = () {
      print('TODO!');
    };
}
