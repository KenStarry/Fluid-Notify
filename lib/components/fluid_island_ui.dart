part of '../fluid_notify.dart';

class FluidIslandUI extends StatefulWidget {
  const FluidIslandUI({super.key});

  @override
  State<FluidIslandUI> createState() => _FluidIslandUIState();
}

class _FluidIslandUIState extends State<FluidIslandUI> {

  late final FluidController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FluidController();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final controller = _controller;
        final isExpanded = controller.isVisible;

        return ElasticContainer(
          // Logic is now handled internally by ElasticContainer
          width: isExpanded ? 250 : 40,
          height: isExpanded ? 60 : 10,
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
          shadow: BoxShadow(
            color: isExpanded ? Colors.black.withValues(alpha: 0.2) : Colors.transparent,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: 60,
                width: 250,
                // Pass content from controller
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: !isExpanded
                      ? null
                      : FluidContent(
                          isVisible: isExpanded,
                          message: controller.message,
                          icon: controller.icon,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
