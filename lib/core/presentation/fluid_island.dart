part of '../../fluid_notify.dart';

/// 2. THE WRAPPER WIDGET
/// Wrap your MaterialApp with this.
class FluidIsland extends StatelessWidget {
  final Widget child;

  const FluidIsland({super.key, required this.child});

  /// The user simply passes this to MaterialApp.builder
  static TransitionBuilder builder({TransitionBuilder? upstreamBuilder}) {
    return (BuildContext context, Widget? child) {
      // 1. If they have another builder, run it first to get the widget tree
      final Widget appContent = upstreamBuilder != null
          ? upstreamBuilder(context, child)
          : child ?? const SizedBox();

      // 2. Wrap the result
      return Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) {
              return FluidIsland(child: appContent);
            },
          ),
        ],
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: FluidController().overlayPortalController,
      overlayChildBuilder: (context) {
        // This builder is what puts the widget ON TOP of everything
        return const Positioned(
          top: 50, // Top margin (Status bar area)
          left: 0,
          right: 0,
          child: Center(child: FluidIslandUI()),
        );
      },
      child: child,
    );
  }
}
