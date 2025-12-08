part of '../fluid_notify.dart';

class Fluid {

  static final _controller = FluidController();


  static void notify(String message, {IconData? icon}) {
    _controller.show(message, icon: icon);
  }

  static void hide() {
    _controller.hide();
  }

}