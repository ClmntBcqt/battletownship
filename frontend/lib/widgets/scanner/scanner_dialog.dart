import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/scanner/camera.dart';
import 'package:provider/provider.dart';

class ScannerDialog extends StatefulWidget {
  const new({super.key, required this.apiService});

  final ApiService apiService;

  @override
  State<ScannerDialog> createState() => _ScannerDialogState();
}

class _ScannerDialogState extends State<ScannerDialog> {
  bool _loading = false;
  String? _error;

  final _textController = TextEditingController();
  Uint8List? _pictureBytes;

  bool get _isNameValid => _textController.text.trim().isNotEmpty;
  bool get _isPictureValid => _pictureBytes != null;
  bool get _isFormValid => !_loading && _isNameValid && _isPictureValid;

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
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: "Nom",
                  errorText: _error,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
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

    var apiService = context.read<ApiService>();
    final townshipName = _textController.text.trim();

    try {
      setState(() {
        _loading = true;
      });

      await apiService.addScan(townshipName, _pictureBytes!);

      if (!mounted) return;

      Navigator.of(context).pop();
    } on DioException catch (e) {
      setState(() {
        _error = e.response?.data['detail'];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
