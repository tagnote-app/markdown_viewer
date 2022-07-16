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
    this.h1Padding,
    this.h2Padding,
    this.h3Padding,
    this.h4Padding,
    this.h5Padding,
    this.h6Padding,
  });

  TextStyle? headline1;
  TextStyle? headline2;
  TextStyle? headline3;
  TextStyle? headline4;
  TextStyle? headline5;
  TextStyle? headline6;
  EdgeInsets? h1Padding;
  EdgeInsets? h2Padding;
  EdgeInsets? h3Padding;
  EdgeInsets? h4Padding;
  EdgeInsets? h5Padding;
  EdgeInsets? h6Padding;

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
  bool isBlock(element) => true;

  @override
  EdgeInsets? blockPadding(element) => {
        "1": h1Padding,
        "2": h2Padding,
        "3": h3Padding,
        "4": h4Padding,
        "5": h5Padding,
        "6": h6Padding,
      }[element.attributes['level']];
}
