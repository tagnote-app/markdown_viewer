class TestCase {
  const TestCase({
    required this.description,
    required this.markdown,
    required this.expected,
  });

  factory TestCase.formJson(Map<String, dynamic> json) {
    final expected = List<Map<String, dynamic>>.from(json['expected'])
        .map((item) => ExpectedElement.formJson(item))
        .toList();

    return TestCase(
      description: json['description'],
      markdown: json['markdown'],
      expected: expected,
    );
  }

  final String description;
  final String markdown;
  final List<ExpectedNode> expected;
}

abstract class ExpectedNode {
  const ExpectedNode();

  Map<String, dynamic> toMap();
}

class ExpectedElement extends ExpectedNode {
  ExpectedElement({
    required this.type,
    required this.isBlock,
    this.children,
  });

  factory ExpectedElement.formJson(Map<String, dynamic> json) {
    ExpectedNode createChild(Map<String, dynamic> data) {
      return data['text'] != null
          ? ExpectedText.formJson(data)
          : ExpectedElement.formJson(data);
    }

    return ExpectedElement(
      type: json['block'] ?? json['inline'],
      isBlock: json['block'] != null,
      children: json['children'] == null
          ? null
          : List<ExpectedNode>.from(
              List<Map<String, dynamic>>.from(json['children']).map(
                createChild,
              ),
            ),
    );
  }

  List<ExpectedNode>? children;
  String type;
  bool isBlock;

  bool get hasSingleChild => children != null && children!.length == 1;
  bool get hasMultiChild => children != null && children!.length > 1;
  bool get hasNoChild => children == null;

  @override
  Map<String, dynamic> toMap() => {
        'type': type,
        'isBlock': isBlock,
        if (children != null)
          'children': children!.map((e) => e.toMap()).toList(),
      };
}

class ExpectedText extends ExpectedNode {
  const ExpectedText({
    required this.text,
  });

  factory ExpectedText.formJson(Map<String, dynamic> json) {
    return ExpectedText(
      text: json['text'],
    );
  }

  final String text;

  @override
  Map<String, dynamic> toMap() => {
        'text': text,
      };
}
