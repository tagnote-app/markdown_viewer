import 'package:dart_markdown/dart_markdown.dart' as md;

import 'extensions.dart';

abstract class NodeVisitor extends md.Visitor<MarkdownText, MarkdownElement> {}

abstract class MarkdownNode {
  const MarkdownNode();
  void accept(NodeVisitor visitor);
  Map<String, dynamic> toMap();
}

class MarkdownElement extends MarkdownNode {
  const MarkdownElement(
    this.type, {
    this.children = const [],
    this.attributes = const {},
  });

  final String type;
  final List<MarkdownNode> children;
  final Map<String, String> attributes;

  @override
  Map<String, dynamic> toMap() => {
        'type': type,
        if (children.isNotEmpty)
          'children': children.map((e) => e.toMap()).toList(),
        if (attributes.isNotEmpty) 'attributes': attributes,
      };

  @override
  String toString() => toMap().toPrettyString();

  @override
  void accept(NodeVisitor visitor) {
    if (visitor.visitElementBefore(this)) {
      if (children.isNotEmpty) {
        for (final child in children) {
          child.accept(visitor);
        }
      }
      visitor.visitElementAfter(this);
    }
  }
}

class MarkdownText extends MarkdownNode {
  const MarkdownText(this.text);
  final String text;

  @override
  Map<String, dynamic> toMap() => {'text': text};

  @override
  String toString() => toMap().toPrettyString();

  @override
  void accept(NodeVisitor visitor) => visitor.visitText(this);
}
