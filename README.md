A Markdown viewer widget for Flutter. It renders Markdown string to rich text
output.

### Dependency

[dart_markdown](https://github.com/chenzhiguang/dart_markdown)

### Usage

```dart
MarkdownViewer(
  'Hello **Markdown**!',
  enableTaskList: true,
  enableSuperscript: false,
  enableSubscript: false,
  enableFootnote: false,
  enableImageSize: false,
  enableKbd: false,
  syntaxExtensions: const [],
  elementBuilders: const [],
);
```
