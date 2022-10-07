import 'package:flutter/material.dart';

import '../definition.dart';
import '../helpers/utils.dart';
import '../widgets/copy_button.dart';
import 'builder.dart';

class CodeBlockBuilder extends MarkdownElementBuilder {
  CodeBlockBuilder({
    TextStyle? textStyle,
    this.padding,
    this.decoration,
    this.highlightBuilder,
  }) : super(textStyle: textStyle);

  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final MarkdownHighlightBuilder? highlightBuilder;

  @override
  final matchTypes = ['codeBlock'];

  @override
  bool replaceLineEndings(String type) => false;

  @override
  TextAlign textAlign(parent) => TextAlign.start;

  @override
  TextSpan buildText(text, parent, selectable) {
    final textContent = text.trimRight();
    final style = const TextStyle(fontFamily: 'monospace').merge(parent.style);

    if (highlightBuilder == null) {
      return TextSpan(
        text: textContent,
        style: style,
        mouseCursor: mouseCursor(selectable),
      );
    }

    final spans = highlightBuilder!(
      textContent,
      parent.attributes['language'],
      parent.attributes['infoString'],
    );

    if (spans.isEmpty) {
      return const TextSpan(text: '');
    }

    return TextSpan(
      children: spans,
      style: style,
      mouseCursor: mouseCursor(selectable),
    );
  }

  @override
  Widget buildWidget(element) {
    const defaultPadding = EdgeInsets.all(8.0);
    final defaultDecoration = BoxDecoration(
      color: const Color(0xfff0f0f0),
      borderRadius: BorderRadius.circular(5),
    );

    Widget child;
    if (element.children.isNotEmpty) {
      final textWidget = element.children.single;
      child = Stack(
        children: [
          Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: padding ?? defaultPadding,
              child: textWidget,
            ),
          ),
          Positioned(right: 0, top: 0, child: CopyButton(textWidget)),
        ],
      );
    } else {
      child = const SizedBox(height: 15);
    }

    return Container(
      width: double.infinity,
      decoration: decoration ?? defaultDecoration,
      child: child,
    );
  }
}
