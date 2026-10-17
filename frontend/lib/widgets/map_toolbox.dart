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
          children: [
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OrientationResetButton(widget: widget),
                    ZoomSlider(widget: widget),
                  ],
                ),
              ),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

class OrientationResetButton extends StatelessWidget {
  const new({super.key, required this.widget});

  final MapToolbox widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => widget.mapController.rotate(0),
      icon: Icon(Icons.explore, color: Theme.of(context).colorScheme.primary),
    );
  }
}

class ZoomSlider extends StatelessWidget {
  const new({super.key, required this.widget});

  final MapToolbox widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: RotatedBox(
        quarterTurns: 3,
        child: Slider(
          value: widget.mapController.camera.zoom,
          min: widget.mapController.camera.minZoom!,
          max: widget.mapController.camera.maxZoom!,
          onChanged: (value) {
            widget.mapController.move(
              widget.mapController.camera.center,
              value,
            );
          },
        ),
      ),
    );
  }
}
