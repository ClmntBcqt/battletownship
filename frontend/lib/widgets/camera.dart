import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Scanner extends StatefulWidget {
  const new({super.key, required this.onPictureContent});

  final ValueChanged<Uint8List?> onPictureContent;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late CameraController _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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
              AspectRatio(
                aspectRatio: _cameraController.value.aspectRatio,
                child: CameraPreview(_cameraController),
              ),
              IconButton.filledTonal(
                onPressed: _cameraController.value.isPreviewPaused
                    ? resetPreview
                    : takePicture,
                icon: Icon(
                  _cameraController.value.isPreviewPaused
                      ? Icons.flip_camera_ios_outlined
                      : Icons.camera_alt_outlined,
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController.initialize();

    setState(() {
      _isCameraReady = true;
    });
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
