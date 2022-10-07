import 'package:flutter/rendering.dart';

MouseCursor? mouseCursor(bool selectable) =>
    selectable ? SystemMouseCursors.text : null;
