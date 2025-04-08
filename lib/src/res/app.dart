// import 'package:Skillify/src/res/dimentions/app_dimensions.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/dimentions/ui.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:flutter/material.dart';

class App {
  static init(BuildContext context) {
    UI.init(context);
    // AppDimensions.init();
    Space.init();
    TextStyles.init();
  }

  // static var box = Hive.box('posBox');
}
