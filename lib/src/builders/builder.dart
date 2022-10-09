import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../ast.dart';
import '../helpers/inline_wraper.dart';
import '../models/markdown_tree_element.dart';
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

  /// The reference of current [MarkdownRenderer] instance.
  late MarkdownRenderer renderer;

  /// Initilizes [renderer] instance.
  void register(MarkdownRenderer renderer) {
    this.renderer = renderer;
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
  void init(MarkdownElement element) {}

  /// Creates a [GestureRecognizer] for the current element and it's
  /// descendants.
  GestureRecognizer? gestureRecognizer(MarkdownElement element) => null;

  /// Builds a [TextStyle] for the current element. It merges the [textStyle]
  /// of current matched element into [parentStyle] and returns the result by
  /// default.
  TextStyle? buildTextStyle(MarkdownElement element, TextStyle defaultStyle) {
    final currentStyle = textStyle ?? textStyleMap?[element.type];
    return defaultStyle.merge(parentStyle).merge(currentStyle);
  }

  /// Runs when current element contains md.Text child.
  ///
  /// The [style] is from [buildTextStyle].
  TextSpan buildText(
    String text,
    MarkdownTreeElement parent,
  ) =>
      TextSpan(
        text: text,
        style: parent.style,
        mouseCursor: renderer.mouseCursor,
      );

  /// Sets a new [TextAlign] instead of using the default one.
  ///
  /// Returns `null` to use the default [TextAlign].
  TextAlign? textAlign(MarkdownTreeElement parent) => null;

  /// To create a TextSpan the same as [buildText] when an element does not have
  /// a md.Text child.
  ///
  /// The [TextSpan] returns from this method will be converted to a [RichText]
  /// widget and merged with other [RichText] widgets if it is possible.
  TextSpan? createText(MarkdownTreeElement element, TextStyle? parentStyle) =>
      null;

  /// If it is a block element, it uses the value from [element] by default.
  bool isBlock(MarkdownTreeElement element) => element.isBlock;

  EdgeInsets? blockPadding(
    MarkdownTreeElement element,
    MarkdownTreeElement parent,
  ) =>
      EdgeInsets.zero;

  /// Updates padding, including:
  ///
  /// Sets `top` to `0` if it is the first element of a block list.\
  /// Sets `bottom` to `0` if it is the last element of a block list.
  EdgeInsets? updatePadding(
    MarkdownTreeElement element,
    MarkdownTreeElement parent,
    EdgeInsets? padding,
  ) {
    if (padding == null || padding == EdgeInsets.zero) {
      return null;
    }

    final position = element.element.position;
    final isLast = position.index + 1 == position.total;
    final isFirst = position.index == 0;

    if (!isLast && !isFirst) {
      return padding;
    }

    var top = padding!.top;
    var bottom = padding.bottom;

    if (isFirst && isLast) {
      top = 0;
      bottom = 0;
    } else if (isFirst) {
      top = 0;
    } else if (isLast) {
      bottom = 0;
    }

    return padding.copyWith(
      top: top,
      bottom: bottom,
      left: padding.left,
      right: padding.right,
    );
  }

  /// Builds a widget of current element and adds to the element tree.
  ///
  /// Nothing will be added to the element tree if returns `null`.
  ///
  /// NOTE: The [RichText] added to [element.children] at this step will not be
  /// merged with other [RichText] widgets. Use [createText] instead if you want
  /// to create a text widget and merge it with other adjacent [RichText]
  /// widgets.
  Widget? buildWidget(MarkdownTreeElement element, MarkdownTreeElement parent) {
    final children = element.children;
    if (children.isEmpty) {
      return null;
    }

    if (!isBlock(element)) {
      return InlineWraper(element.children);
    }

    final widget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    final padding = updatePadding(
      element,
      parent,
      blockPadding(element, parent),
    );

    if (padding == null || padding == EdgeInsets.zero) {
      return widget;
    }

    return Padding(
      padding: padding,
      child: widget,
    );
  }
}

typedef Attributes = Map<String, String>;
