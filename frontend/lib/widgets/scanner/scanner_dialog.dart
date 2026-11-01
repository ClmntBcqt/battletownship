import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/dtos/township_suggestion.dart';
import 'package:frontend/services/map_service.dart';
import 'package:frontend/widgets/scanner/camera.dart';
import 'package:frontend/widgets/scanner/township_field.dart';
import 'package:provider/provider.dart';

class ScannerDialog extends StatefulWidget {
  const new({super.key, required this.mapService});

  final MapService mapService;

  @override
  State<ScannerDialog> createState() => _ScannerDialogState();
}

class _ScannerDialogState extends State<ScannerDialog> {
  bool _loading = false;

  TownshipSuggestionDto? _township;
  Uint8List? _pictureBytes;

  bool get _isTownshipValid => _township != null;
  bool get _isPictureValid => _pictureBytes != null;
  bool get _isFormValid => !_loading && _isTownshipValid && _isPictureValid;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Scanner une commune")),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              TownshipField(
                onSelected: (suggestion) => setState(() {
                  _township = suggestion;
                }),
              ),
              Camera(
                onPictureContent: (pictureContent) => setState(() {
                  _pictureBytes = pictureContent;
                }),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Annuler"),
        ),
        FilledButton(
          onPressed: _isFormValid ? sendScan : null,
          child: _loading ? CircularProgressIndicator() : Text("Ok"),
        ),
      ],
    );
  }

  Future<void> sendScan() async {
    if (!_isFormValid) return;

    var mapService = context.read<MapService>();

    setState(() {
      _loading = true;
    });

    await mapService.addScan(_township!.code, _pictureBytes!);

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    Navigator.of(context).pop();
  }
}
