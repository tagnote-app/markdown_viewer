import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../definition.dart';
import '../renderer.dart';

abstract class MarkdownElementBuilder {
  MarkdownElementBuilder({
    this.textStyle,
    this.textStyleMap,
  }) {
    assert(matchTypes.isNotEmpty);
    assert(
      textStyle == null || textStyleMap == null,
      "You should set either textStyle or textStyleMap",
    );
    assert(
      !(matchTypes.length > 1 && textStyle != null),
      "You should set textStyleMap when matches more than one element."
      "The matchTypes is $matchTypes",
    );
  }

  /// Which element types should it match.
  List<String> get matchTypes;

  /// [TextStyle] of the current element.
  final TextStyle? textStyle;

  /// If [matchTypes] matches more than one type, you need to use textStyleMap
  /// to set [TextStyle] for each type.
  final Map<String, TextStyle?>? textStyleMap;

  /// [TextStyle] of the parent element.
  TextStyle? parentStyle;

  /// Whether to replace line endings with whitespaces.
  /// It effects all the descendants of current element.
  bool replaceLineEndings(String type) => true;

  /// Called when an Element has been reached, before it's children have been
  /// built.
  void before(String type, Attributes attributes) {}

  /// Creates a [GestureRecognizer] for the current element and it's
  /// descendants.
  GestureRecognizer? gestureRecognizer(String type, Attributes attributes) =>
      null;

  /// Builds a [TextStyle] for the current element. It merges the [textStyle]
  /// of current matched element into [parentStyle] and returns the result by
  /// default.
  TextStyle? buildTextStyle(String type, Attributes attributes) {
    final currentStyle = textStyle ?? textStyleMap?[type];

    return parentStyle?.merge(currentStyle) ?? currentStyle;
  }

  /// Runs when current element contains md.Text child.
  ///
  /// The [style] is from [buildTextStyle].
  TextSpan buildText(String text, MarkdownTreeElement parent) => TextSpan(
        text: text,
        style: parent.style,
      );

  /// Sets a new [TextAlign] instead of using the default one.
  ///
  /// Returns `null` to use the default [TextAlign].
  TextAlign? textAlign(MarkdownTreeElement parent) => null;

  /// Runs when current element does not have md.Text, such as hardBreak.
  TextSpan? createText(MarkdownTreeElement element, TextStyle? parentStyle) =>
      null;

  /// Called after current element has been built.
  void after(MarkdownRenderer renderer, MarkdownTreeElement element) {}
}

typedef Attributes = Map<String, String>;
