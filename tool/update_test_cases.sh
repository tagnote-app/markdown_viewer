#!/bin/sh

BUILDER_DIR=".test_case_builder"
SRC_DIR="lib/src"
TEST_DIR="test"
TOOLS_DIR="tool/case_builder"


mkdir -p $BUILDER_DIR
rm -rf ./$BUILDER_DIR/*

cp -r $SRC_DIR/builders ./$BUILDER_DIR/builders
cp  $SRC_DIR/ast.dart ./$BUILDER_DIR/ast.dart
cp  $SRC_DIR/definition.dart ./$BUILDER_DIR/definition.dart
cp  $SRC_DIR/extensions.dart ./$BUILDER_DIR/extensions.dart
cp  $SRC_DIR/helpers.dart ./$BUILDER_DIR/helpers.dart
cp  $SRC_DIR/renderer.dart ./$BUILDER_DIR/renderer.dart
cp  $SRC_DIR/style.dart ./$BUILDER_DIR/style.dart
cp  $SRC_DIR/transformer.dart ./$BUILDER_DIR/transformer.dart

cp $TEST_DIR/theme_data.dart ./$BUILDER_DIR/
cp $TOOLS_DIR/case_builder.dart ./$BUILDER_DIR/
cp $TOOLS_DIR/fake_ui.dart ./$BUILDER_DIR/


FILES="import 'renderer.dart';
import 'extensions.dart';
import 'style.dart';
import 'theme_data.dart';";


perl -pi -w -e 's/package:flutter\/material\.dart/fake_ui\.dart/g;' ./$BUILDER_DIR/*.dart
perl -pi -w -e "s/import 'package:flutter\/gestures\.dart';\n//g;" ./$BUILDER_DIR/*.dart

perl -pi -w -e 's/package:flutter\/material\.dart/\.\.\/fake_ui\.dart/g;' ./$BUILDER_DIR/builders/*.dart
perl -pi -w -e "s/import 'package:flutter\/gestures\.dart';\n//g;" ./$BUILDER_DIR/builders/*.dart
perl -pi -w -e "s/import 'dart:ui';\n//g;" ./$BUILDER_DIR/style.dart
perl -pi -w -e "s/import 'dummy_builder\.dart';/$FILES/g;" ./$BUILDER_DIR/case_builder.dart
perl -pi -w -e "s/const caseBuilderDisabled = true;/const caseBuilderDisabled = false;/g;" ./$BUILDER_DIR/case_builder.dart

dart $BUILDER_DIR/case_builder.dart
