bool isBlockElement(String type) => _blockTypes.contains(type);

const _blockTypes = [
  'paragraph',
  'atxHeading',
  'setextHeading',
  'htmlBlock',
  'bulletList',
  'orderedList',
  'listItem',
  'thematicBreak',
  'blockquote',
  'fencedBlockquote',
  'indentedCodeBlock',
  'fencedCodeBlock',
  'table',
  'tableRow',
  'tableHead',
  'tableBody',
];


// == INLINE TYPES ==
// link
// image
// autolink
// hardLineBreak
// emphasis
// strongEmphasis
// emoji
// codeSpan
// backslashEscape
// extendedAutolink
// rawHtml
// tableBodyCell
// tableHeadCell

// linkReferenceDefinition
// linkReferenceDefinitionLabel
// linkReferenceDefinitionDestination
// linkReferenceDefinitionTitle