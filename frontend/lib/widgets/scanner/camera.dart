import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Camera extends StatefulWidget {
  const new({super.key, required this.onPictureContent});

  final ValueChanged<Uint8List?> onPictureContent;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _cameraController;
  bool _isCameraReady = false;
  bool _isAccessDenied = false;

  final List<CameraDescription> _availableCameras = [];
  late int _selectedCameraIndex;
  CameraDescription get _selectedCamera =>
      _availableCameras.elementAt(_selectedCameraIndex);

  double? get _previewContainerWidth =>
      switch (_cameraController.value.deviceOrientation) {
        .portraitUp ||
        .portraitDown => _cameraController.value.previewSize?.height,
        _ => _cameraController.value.previewSize?.width,
      };
  double? get _previewContainerHeight =>
      switch (_cameraController.value.deviceOrientation) {
        .portraitUp ||
        .portraitDown => _cameraController.value.previewSize?.width,
        _ => _cameraController.value.previewSize?.height,
      };

  @override
  void initState() {
    super.initState();

    getAvailableCameras().then((_) {
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
    return Column(
      spacing: 16,
      children: [
        Stack(
          alignment: .bottomCenter,
          children: [
            ClipRRect(
              borderRadius: .circular(16),
              child: SizedBox(
                width: 300,
                height: 225, // 4:3 format
                child: _isAccessDenied
                    ? Column(
                        mainAxisAlignment: .center,
                        children: [
                          Center(
                            child: Text(
                              "Accès à la caméra refusé. Vous pouvez modifier les autorisations dans vos paramètres.",
                              textAlign: .center,
                            ),
                          ),
                        ],
                      )
                    : _isCameraReady
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _previewContainerWidth,
                          height: _previewContainerHeight,
                          child: CameraPreview(_cameraController),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
            if (_isCameraReady)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transform.scale(
                  scale: 1.3,
                  child: Align(
                    alignment: .bottomCenter,
                    child: IconButton.filled(
                      onPressed: _cameraController.value.isPreviewPaused
                          ? resetPreview
                          : takePicture,
                      icon: Icon(
                        _cameraController.value.isPreviewPaused
                            ? Icons.flip_camera_ios_outlined
                            : Icons.camera_alt_outlined,
                      ),
                    ),
                  ),
                ),
              ),
            if (_isCameraReady)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: .bottomStart,
                  child: IconButton.filledTonal(
                    onPressed: () async => await _nextCamera(),
                    icon: Icon(Icons.flip_camera_android),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
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

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
        setState(() {
          _isAccessDenied = true;
        });
      }
    }

    setState(() {
      _isCameraReady = true;
    });
  }

  Future<void> getAvailableCameras() async {
    List<CameraDescription> cameras = [];
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
        setState(() {
          _isAccessDenied = true;
        });
      }
    }

    setState(() {
      _availableCameras.addAll(cameras);
    });

    setState(() {
      _selectedCameraIndex = 0;
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
