import 'package:flutter/material.dart';

import '../state/fluid_controller.dart';

/// 4. THE PUBLIC API
/// A helper class to make calling it cleaner.
class Fluid {
  static void notify(String message, {IconData? icon}) {
    FluidController().show(message, icon: icon);
  }

  static void hide() {
    FluidController().hide();
  }

}