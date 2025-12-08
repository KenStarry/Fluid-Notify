part of '../../../fluid_notify.dart';

class FluidIslandUI extends StatefulWidget {
  const FluidIslandUI({super.key});

  @override
  State<FluidIslandUI> createState() => _FluidIslandUIState();
}

class _FluidIslandUIState extends State<FluidIslandUI> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FluidController(),
      builder: (context, _) {
        final controller = FluidController();
        final isExpanded = controller.isVisible;

        return AnimatedContainer(
          /// Physics
          curve: Curves.elasticOut,
          duration: const Duration(milliseconds: 800),

          // Sizing logic
          height: isExpanded ? 60 : 10,
          width: isExpanded ? 250 : 40,

          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              if (isExpanded)
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: 60,
                width: 250,
                // Pass content from controller
                child: FluidContent(
                  isVisible: isExpanded,
                  message: controller.message,
                  icon: controller.icon,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
