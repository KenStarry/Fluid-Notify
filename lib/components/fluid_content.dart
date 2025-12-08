part of '../fluid_notify.dart';

class FluidContent extends StatelessWidget {
  final bool isVisible;
  final String message;
  final IconData? icon;

  const FluidContent({
    super.key,
    required this.isVisible,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: isVisible ? 1.0 : 0.0,
      curve: Curves.easeIn,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.greenAccent, size: 24),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.none,
                // Crucial for overlay text
                fontFamily: 'Roboto', // Ensures it looks normal
              ),
            ),
          ),
        ],
      ),
    );
  }
}
