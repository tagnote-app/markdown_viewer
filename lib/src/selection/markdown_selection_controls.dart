import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'desktop_text_selection_toolbar.dart';
import 'mobile_text_selection_toolbar.dart';

class MarkdownSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textHeight, [
    VoidCallback? onTap,
  ]) {
    return _isDesktop(context)
        ? const SizedBox.shrink()
        : super.buildHandle(context, type, textHeight, onTap);
  }

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    if (_isDesktop(context)) {
      return DesktopTextSelectionToolbar(
        clipboardStatus: clipboardStatus,
        endpoints: endpoints,
        globalEditableRegion: globalEditableRegion,
        handleCopy: canCopy(delegate) ? () => handleCopy(delegate) : null,
        handleSelectAll:
            canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
        selectionMidpoint: selectionMidpoint,
        lastSecondaryTapDownPosition: lastSecondaryTapDownPosition,
        textLineHeight: textLineHeight,
      );
    } else {
      return MobileTextSelectionToolbar(
        globalEditableRegion: globalEditableRegion,
        textLineHeight: textLineHeight,
        selectionMidpoint: selectionMidpoint,
        endpoints: endpoints,
        delegate: delegate,
        clipboardStatus: clipboardStatus,
        handleCopy: canCopy(delegate) ? () => _handleCopy(delegate) : null,
        handleSelectAll:
            canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
      );
    }
  }

  void _handleCopy(TextSelectionDelegate delegate) {
    delegate.copySelection(SelectionChangedCause.toolbar);
    _updateClipboard();
  }

  // TODO(Zhiguang): Remove it when this issue is fixed:
  // https://github.com/flutter/flutter/issues/104548
  Future<void> _updateClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData == null || clipboardData.text == null) {
      return;
    }

    final text = clipboardData.text!.replaceAll(' \n', '\n');
    await Clipboard.setData(ClipboardData(text: text));
  }

  bool _isDesktop(BuildContext context) {
    return [TargetPlatform.windows, TargetPlatform.linux, TargetPlatform.macOS]
        .contains(Theme.of(context).platform);
  }
}
