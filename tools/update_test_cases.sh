#!/bin/sh

BUILDER_DIR="test_case_builder"
SRC_DIR="lib/src"
TEST_DIR="test"
TOOLS_DIR="tools/case_builder"


mkdir -p $BUILDER_DIR
rm -rf ./$BUILDER_DIR/*

cp $SRC_DIR/builder.dart ./$BUILDER_DIR/
cp $SRC_DIR/extensions.dart ./$BUILDER_DIR/
cp $SRC_DIR/helpers.dart ./$BUILDER_DIR/
cp $SRC_DIR/style.dart ./$BUILDER_DIR/
cp $SRC_DIR/tree_element.dart ./$BUILDER_DIR/
cp $TEST_DIR/theme_data.dart ./$BUILDER_DIR/
cp $TOOLS_DIR/case_builder.dart ./$BUILDER_DIR/
cp $TOOLS_DIR/fake_ui.dart ./$BUILDER_DIR/


FILES="import 'builder.dart';
import 'extensions.dart';
import 'style.dart';
import 'theme_data.dart';";


perl -pi -w -e 's/package:flutter\/material\.dart/fake_ui\.dart/g;' ./$BUILDER_DIR/*.dart
perl -pi -w -e "s/import 'package:flutter\/gestures\.dart';\n//g;" ./$BUILDER_DIR/builder.dart
perl -pi -w -e "s/import 'dummy_builder\.dart';/$FILES/g;" ./$BUILDER_DIR/case_builder.dart
perl -pi -w -e "s/const caseBuilderDisabled = true;/const caseBuilderDisabled = false;/g;" ./$BUILDER_DIR/case_builder.dart

dart $BUILDER_DIR/case_builder.dart
