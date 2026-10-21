import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Scanner extends StatefulWidget {
  const new({super.key, required this.onPictureContent});

  final ValueChanged<Uint8List?> onPictureContent;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late CameraController _cameraController;
  bool _isCameraReady = false;

  final List<CameraDescription> _availableCameras = [];
  late int _selectedCameraIndex;
  CameraDescription get _selectedCamera =>
      _availableCameras.elementAt(_selectedCameraIndex);

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      setState(() {
        _availableCameras.addAll(cameras);
      });

      setState(() {
        _selectedCameraIndex = 0;
      });

      if (_availableCameras.isEmpty) return;

      _initializeCamera(_selectedCamera);
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isCameraReady
        ? Column(
            spacing: 16,
            children: [
              Stack(
                alignment: .bottomCenter,
                children: [
                  CameraPreview(_cameraController),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        IconButton.filled(
                          onPressed: _cameraController.value.isPreviewPaused
                              ? resetPreview
                              : takePicture,
                          icon: Icon(
                            _cameraController.value.isPreviewPaused
                                ? Icons.flip_camera_ios_outlined
                                : Icons.camera_alt_outlined,
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () async => await _nextCamera(),
                          icon: Icon(Icons.flip_camera_android),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    setState(() {
      _isCameraReady = false;
    });

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController.initialize();

    setState(() {
      _isCameraReady = true;
    });
  }

  Future<void> _nextCamera() async {
    _selectedCameraIndex =
        (_selectedCameraIndex + 1) % _availableCameras.length;

    await _initializeCamera(_selectedCamera);
  }

  Future<void> takePicture() async {
    await _cameraController.pausePreview();
    var picture = await _cameraController.takePicture();
    var pictureBytes = await picture.readAsBytes();
    widget.onPictureContent(pictureBytes);
    setState(() {});
  }

  Future<void> resetPreview() async {
    widget.onPictureContent(null);
    await _cameraController.resumePreview();
    setState(() {});
  }
}
