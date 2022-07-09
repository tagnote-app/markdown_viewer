import 'package:flutter/material.dart';

import 'builder.dart';

class HeadlineBuilder extends MarkdownElementBuilder {
  HeadlineBuilder({
    this.headline1,
    this.headline2,
    this.headline3,
    this.headline4,
    this.headline5,
    this.headline6,
  });

  TextStyle? headline1;
  TextStyle? headline2;
  TextStyle? headline3;
  TextStyle? headline4;
  TextStyle? headline5;
  TextStyle? headline6;

  @override
  TextStyle? buildTextStyle(type, attributes) => {
        "1": headline1,
        "2": headline2,
        "3": headline3,
        "4": headline4,
        "5": headline5,
        "6": headline6,
      }[attributes['level']];

  @override
  final matchTypes = ['headline'];

  @override
  void after(renderer, element) {
    renderer.write(renderer.convertToBlock(element.children));
  }
}
