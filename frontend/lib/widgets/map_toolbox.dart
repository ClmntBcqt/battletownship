import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapToolbox extends StatefulWidget {
  const new({super.key, required this.mapController});

  final MapController mapController;

  @override
  State<MapToolbox> createState() => _MapToolboxState();
}

class _MapToolboxState extends State<MapToolbox> {
  late final StreamSubscription<MapEvent> _mapEventSubscription;

  @override
  void initState() {
    super.initState();

    // rebuild this widget when map change to keep synchronisation
    _mapEventSubscription = widget.mapController.mapEventStream.listen(
      (event) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _mapEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.centerEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            OrientationResetButton(mapController: widget.mapController),
            ZoomSlider(mapController: widget.mapController),
          ],
        ),
      ),
    );
  }
}

class OrientationResetButton extends StatefulWidget {
  const OrientationResetButton({super.key, required this.mapController});

  final MapController mapController;

  @override
  State<OrientationResetButton> createState() => _OrientationResetButtonState();
}

class _OrientationResetButtonState extends State<OrientationResetButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Durations.long1);
    _rotation = AlwaysStoppedAnimation(widget.mapController.camera.rotation);

    _controller.addListener(() {
      widget.mapController.rotate(_rotation.value);
    });
  }

  void _resetOrientation() {
    final currentRotation = widget.mapController.camera.rotation;
    final begin = currentRotation > 180
        ? -(360 - currentRotation)
        : currentRotation;

    _rotation = Tween<double>(begin: begin, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: .circle,
      ),
      child: IconButton(
        onPressed: _resetOrientation,
        icon: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: widget.mapController.camera.rotationRad,
              child: child,
            );
          },
          child: Icon(Icons.navigation, color: Colors.red.shade700),
        ),
      ),
    );
  }
}

class ZoomSlider extends StatelessWidget {
  const new({super.key, required this.mapController});

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => mapController.move(
              mapController.camera.center,
              mapController.camera.zoom + 1,
            ),
            icon: Icon(Icons.add),
            iconSize: 16,
          ),
          SizedBox(
            width: 40,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: mapController.camera.zoom,
                min: mapController.camera.minZoom!,
                max: mapController.camera.maxZoom!,
                onChanged: (value) {
                  mapController.move(mapController.camera.center, value);
                },
                padding: EdgeInsets.all(4),
              ),
            ),
          ),
          IconButton(
            onPressed: () => mapController.move(
              mapController.camera.center,
              mapController.camera.zoom - 1,
            ),
            icon: Icon(Icons.remove),
            iconSize: 16,
          ),
        ],
      ),
    );
  }
}
