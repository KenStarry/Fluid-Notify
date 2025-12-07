import 'package:flutter/material.dart';

/// 1. THE CONTROLLER
/// This singleton manages the state of the island globally.
class FluidController extends ChangeNotifier {
  // Singleton pattern so we can access it anywhere
  static final FluidController _instance = FluidController._internal();

  factory FluidController() => _instance;

  FluidController._internal();

  // The overlay controller required by OverlayPortal
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();

  bool _isVisible = false;
  String _message = "";
  IconData? _icon;

  // Getters for the UI to consume
  bool get isVisible => _isVisible;

  String get message => _message;

  IconData? get icon => _icon;

  /// Call this to show a notification
  void show(String message, {IconData? icon}) {
    _message = message;
    _icon = icon;
    _isVisible = true;
    notifyListeners(); // Tell the UI to update

    if (!overlayPortalController.isShowing) {
      overlayPortalController.show();
    }

    Future.delayed(const Duration(seconds: 3), () {
      hide();
    });
  }

  /// Call this to hide it manually
  void hide() {
    _isVisible = false;
    notifyListeners();
    // We don't hide the OverlayPortal immediately to allow the shrink animation to finish
    // Ideally, you'd wait for the animation duration here
  }
}
