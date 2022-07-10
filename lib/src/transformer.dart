import 'package:markdown/markdown.dart' as md;

import 'ast.dart';

/// Transform the Markdown AST to the AST fits for Flutter usage.
List<MarkdownNode> transformAst(List<md.Node> nodes) {
  final result = <MarkdownNode>[];
  // Merge the adjacent Text nodes into one.
  final stringBuffer = StringBuffer();

  void popBuffer() {
    if (stringBuffer.isNotEmpty) {
      result.add(MarkdownText(stringBuffer.toString()));
      stringBuffer.clear();
    }
  }

  for (final node in nodes) {
    if (node is md.Text) {
      stringBuffer.write(node.textContent);
    } else if (node is md.Element) {
      if (['blankLine', 'linkReferenceDefinition'].contains(node.type)) {
        continue;
      }

      popBuffer();
      result.add(MarkdownElement(
        node.type,
        attributes: node.attributes,
        children: transformAst(node.children),
      ));
    } else {
      throw ArgumentError(
        'Unknown Markdown AST node type ${node.runtimeType}',
      );
    }
  }
  popBuffer();

  return result;
}
