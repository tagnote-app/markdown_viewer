import 'dart:io';

import 'package:flutter/material.dart';

import '../definition.dart';
import '../renderer.dart';
import 'builder.dart';

class ImageBuilder extends MarkdownElementBuilder {
  ImageBuilder({
    this.imageBuilder,
    this.enableImageSize = false,
    this.imageAlignment,
  });

  final MarkdownImageBuilder? imageBuilder;
  final MarkdownImageAlignment? imageAlignment;
  final bool enableImageSize;

  @override
  final matchTypes = ['image'];

  @override
  void after(MarkdownRenderer renderer, MarkdownTreeElement element) {
    final destination = element.attributes['destination']!;
    if (destination.isEmpty) {
      return;
    }
    final description = element.attributes['description'];
    final title = element.attributes['title'];

    String path;
    double? width;
    double? height;
    if (enableImageSize) {
      final parsedDestination = _parseDestination(destination);
      path = parsedDestination.path;
      width = parsedDestination.width;
      height = parsedDestination.height;
    } else {
      path = destination;
    }

    final uri = Uri.parse(path);

    Widget? child;
    if (imageBuilder != null) {
      child = imageBuilder!(
        uri,
        _MarkdownImageInfo(
          title: title,
          description: description,
          width: width,
          height: height,
        ),
      );
    } else {
      child = _buildImage(uri, width, height);
    }
    if (child == null) {
      return;
    }

    final alignment = {
      MarkdownImageAlignment.left: Alignment.topLeft,
      MarkdownImageAlignment.center: Alignment.topCenter,
      MarkdownImageAlignment.right: Alignment.topRight,
    }[imageAlignment];

    renderer.writeBlock(Align(
      alignment: alignment ?? Alignment.center,
      child: child,
    ));
  }

  _ParseDestination _parseDestination(String destination) {
    final dimensionsPattern = RegExp(r'#([0-9]{1,4})(?:x([0-9]{1,4}))?$');
    final dimensionsMatch = dimensionsPattern.firstMatch(destination);

    String path;
    double? width;
    double? height;
    if (dimensionsMatch == null) {
      path = destination;
    } else {
      path = destination.substring(0, dimensionsMatch.start);
      width = double.parse(dimensionsMatch[1]!);
      if (dimensionsMatch[2] != null) {
        height = double.parse(dimensionsMatch[2]!);
      } else {
        height = width;
      }
    }

    return _ParseDestination(
      path: path,
      width: width,
      height: height,
    );
  }

  Widget? _buildImage(Uri uri, double? width, double? height) {
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return Image.network(uri.toString(), width: width, height: height);
    } else if (uri.scheme == 'data') {
      if (uri.data!.mimeType.startsWith('image/')) {
        return Image.memory(
          uri.data!.contentAsBytes(),
          width: width,
          height: height,
        );
      }
      return null;
    } else if (uri.scheme == 'resource') {
      return Image.asset(uri.path, width: width, height: height);
    } else {
      return Image.file(File.fromUri(uri), width: width, height: height);
    }
  }
}

class _ParseDestination {
  const _ParseDestination({
    required this.path,
    required this.width,
    required this.height,
  });
  final String path;
  final double? width;
  final double? height;
}

class _MarkdownImageInfo extends MarkdownImageInfo {
  _MarkdownImageInfo({
    String? title,
    String? description,
    double? width,
    double? height,
  }) : super(
            title: title,
            description: description,
            width: width,
            height: height);
}
