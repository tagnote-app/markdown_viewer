import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

void main() {
  testWidgets('when empty', ((tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MarkdownViewer(''),
      ),
    );

    final allWidgets = tester.allWidgets;

    expect(allWidgets.elementAt(0).runtimeType, Directionality);
    expect(allWidgets.elementAt(1).runtimeType, MarkdownViewer);
    expect(allWidgets.elementAt(2).runtimeType, SizedBox);
    final sizedBox = allWidgets.elementAt(2) as SizedBox;
    expect(
      {'width': sizedBox.width, 'height': sizedBox.height},
      {'width': 0.0, 'height': 0.0},
    );
  }));

  testWidgets('when has only one block child', ((tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MarkdownViewer('Foo'),
      ),
    );

    final allWidgets = tester.allWidgets;

    // This column is from MarkdownBuilder.
    expect(allWidgets.elementAt(2).runtimeType, Column);
    expect(allWidgets.elementAt(3).runtimeType, Wrap);
  }));

  testWidgets('when has multiple block child', ((tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MarkdownViewer('bar\n# Foo'),
      ),
    );

    final allWidgets = tester.allWidgets;

    // This column is from MarkdownViewer widget.
    expect(allWidgets.elementAt(2).runtimeType, Column);

    // This column is from MarkdownBuilder.
    expect(allWidgets.elementAt(3).runtimeType, Column);
  }));
}
