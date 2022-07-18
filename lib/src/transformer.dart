import 'ast.dart';
import 'definition.dart';

/// Transform the Markdown AST to the AST fits for Flutter usage.
class AstTransformer {
  AstTransformer();

  final _footnoteReferences = <MdElement>[];

  List<MarkdownNode> transform(List<MdNode> nodes) {
    final result = _iterateNodes(nodes);

    if (_footnoteReferences.isNotEmpty) {
      result.add(_buildFootnoteReference());
    }

    return result;
  }

  List<MarkdownNode> _iterateNodes(List<MdNode> nodes) {
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
      if (node is MdText) {
        stringBuffer.write(node.textContent);
      } else if (node is MdElement) {
        if ([
          'blankLine',
          'linkReferenceDefinition',
          'footnoteReference',
        ].contains(node.type)) {
          if (node.attributes['number'] != null) {
            _footnoteReferences.add(node);
          }

          continue;
        }

        if (node.type == 'emoji') {
          stringBuffer.write(node.attributes['emoji']);
          continue;
        }

        popBuffer();
        result.add(MarkdownElement(
          node.type,
          isBlock: node.isBlock,
          attributes: node.attributes,
          children: _iterateNodes(node.children),
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

  MarkdownElement _buildFootnoteReference() {
    _footnoteReferences.sort(
      (a, b) => a.attributes['number']!.compareTo(b.attributes['number']!),
    );

    final listItem = _footnoteReferences
        .map((e) => MarkdownElement(
              'listItem',
              isBlock: e.isBlock,
              attributes: {'number': e.attributes['number']!},
              children: _iterateNodes(e.children),
            ))
        .toList();

    return MarkdownElement(
      'footnoteReference',
      children: [
        MarkdownElement(
          'orderedList',
          isBlock: true,
          children: listItem,
        )
      ],
      isBlock: true,
    );
  }
}
