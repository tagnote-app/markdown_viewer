## 0.3.0-dev

- **Breaking chang**: Change return type of `MarkdownHighlightBuilder` from
  `TextSpan` to `List<TextSpan>`.
- **Breaking chang**: Remove `selectable` option from `MarkdownViewer` and
  `MarkdownRenderer`.
- Add a new optional parameter `selectionColor` to `MarkdownViewer`, the text
  will become selectable when the value is not `null`.
- Add optional parameters `selectionRegistrar` and `selectionColor` to
  `MarkdownRenderer`.

## 0.2.1

- Add `enableAutolinkExtension` option to widget
- Add `nodesFilter` option to widget
- Add `selectable` option to widget
- Update to `dart_markdown` 2.1.0

## 0.2.0+2

- Fix an issue on `highlightBuilder`
  [PR 22](https://github.com/chenzhiguang/markdown_viewer/pull/22)

## 0.2.0+1

- Update README.
- Fix a minor mistake.

## 0.2.0

- Update `dart_markdown` dependency to 2.0.0.
- Set default value for `MarkdownElementBuilder.isBlock`.

## 0.1.0

- First stable version.

## 0.0.1

- Initial release.
