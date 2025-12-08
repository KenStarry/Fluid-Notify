part of '../../fluid_notify.dart';

/// 2. THE WRAPPER WIDGET
/// Wrap your MaterialApp with this.
class FluidIsland extends StatelessWidget {
  final Widget child;

  const FluidIsland({super.key, required this.child});

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
