import 'package:flutter/material.dart';
import 'dart:math' as math;

class ElasticContainer extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final BorderRadius borderRadius;
  final BoxShadow? shadow;

  const ElasticContainer({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    required this.color,
    required this.borderRadius,
    this.shadow,
  });

  @override
  State<ElasticContainer> createState() => _ElasticContainerState();
}

class _ElasticContainerState extends State<ElasticContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _squishAnimation;

  // Track previous sizes to determine animation direction
  double _oldWidth = 0;
  double _oldHeight = 0;

  @override
  void initState() {
    super.initState();
    _oldWidth = widget.width;
    _oldHeight = widget.height;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Slightly faster for snap
    );

    // Initialize animations with default values
    _setupAnimations(beginW: widget.width, endW: widget.width, beginH: widget.height, endH: widget.height);
  }

  void _setupAnimations({required double beginW, required double endW, required double beginH, required double endH}) {
    // 1. Springy Size Animation
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _widthAnimation = Tween<double>(begin: beginW, end: endW).animate(curved);
    _heightAnimation = Tween<double>(begin: beginH, end: endH).animate(curved);

    // 2. The Squish (Distortion) Logic
    // If we are expanding width (getting fatter), we squish height (get flatter) briefly
    bool expanding = endW > beginW;

    _squishAnimation = TweenSequence<double>([
      // Phase 1: Distort quickly as we move
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: expanding ? 1.05 : 0.95)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      // Phase 2: Snap back to normal with a wobble
      TweenSequenceItem(
        tween: Tween<double>(begin: expanding ? 1.05 : 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 80,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(ElasticContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only animate if size actually changed
    if (widget.width != oldWidget.width || widget.height != oldWidget.height) {
      _oldWidth = oldWidget.width;
      _oldHeight = oldWidget.height;

      _setupAnimations(
          beginW: _oldWidth,
          endW: widget.width,
          beginH: _oldHeight,
          endH: widget.height
      );

      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate dynamic distortion
        // If we are animating, use the squish value.
        // We invert the Y squish to maintain "area" (mass).
        double scaleX = _squishAnimation.value;
        double scaleY = 1 + (1 - scaleX); // Crude inverse to keep mass roughly equal

        return Transform(
          // Pivot relative to the Top Center (so it grows down from the notch)
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..scale(scaleX, scaleY),
          child: Container(
            width: _widthAnimation.value.clamp(0.0, double.infinity),
            height: _heightAnimation.value.clamp(0.0, double.infinity),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: widget.borderRadius,
              boxShadow: widget.shadow != null ? [widget.shadow!] : [],
            ),
            // We use a separate transform for the child to UN-SQUISH it
            // so the text doesn't look stretched.
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(1 / scaleX, 1 / scaleY),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}