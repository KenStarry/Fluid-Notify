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

  // Set this to true by default to force the OverlayPortal to appear
  // when the FluidIsland widget first builds.
  bool _overlayLayerVisible = true;

  // Getter for the FluidIsland widget to consume
  bool get overlayLayerVisible => _overlayLayerVisible;

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

    // Ensure the overall overlay layer is showing when we have content
    if (!_overlayLayerVisible) {
      _overlayLayerVisible = true;
      // Notify listeners to trigger the FluidIsland to show the OverlayPortal
      notifyListeners();
    }

    if (!overlayPortalController.isShowing) {
      overlayPortalController.show();
    }

    Future.delayed(const Duration(seconds: 3), () {
      hide();
    });
  }

  /// Call this to hide it manually
  void hide() async {
    if (!_isVisible) return;

    _isVisible = false;
    _overlayLayerVisible = false;
    notifyListeners();

    // await Future.delayed(Duration(milliseconds: 400));

    // if (overlayPortalController.isShowing) {
    //   overlayPortalController.hide();
    // }
    // We don't hide the OverlayPortal immediately to allow the shrink animation to finish
    // Ideally, you'd wait for the animation duration here
  }
}
