import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../definition.dart';

class CopyButton extends StatefulWidget {
  const CopyButton(
    this.textWidget, {
    this.iconBuilder,
    super.key,
  });

  final Widget textWidget;
  final CopyIconBuilder? iconBuilder;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        child: widget.iconBuilder == null
            ? SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  _copied ? Icons.check : Icons.copy_rounded,
                  size: 18,
                  color: _copied ? Colors.black : Colors.black54,
                ),
              )
            : widget.iconBuilder!(_copied),
        onTap: () async {
          final textWidget = widget.textWidget;
          String? text;
          if (textWidget is RichText) {
            text = textWidget.text.toPlainText();
          }
          await Clipboard.setData(ClipboardData(text: text));
          setState(() {
            _copied = true;
            Future.delayed(const Duration(seconds: 1)).then((value) {
              if (mounted) {
                setState(() {
                  _copied = false;
                });
              }
            });
          });
        },
      ),
    );
  }
}
