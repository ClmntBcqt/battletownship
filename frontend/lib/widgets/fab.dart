import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/township_service.dart';
import 'package:frontend/widgets/camera.dart';
import 'package:provider/provider.dart';

class Fab extends StatefulWidget {
  const new({super.key});

  @override
  State<Fab> createState() => _FabState();
}

class _FabState extends State<Fab> {
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    var townshipService = context.read<TownshipService>();
    return SizedBox(
      width: 72,
      height: 72,
      child: FloatingActionButton(
        onPressed: () => showAddTownshipPopup(context, townshipService),
        child: Icon(Icons.add, size: 40),
      ),
    );
  }

  Future<void> showAddTownshipPopup(
    BuildContext context,
    TownshipService townshipService,
  ) {
    return showDialog<String>(
      context: context,
      builder: (context) => AddTownshipDialog(townshipService: townshipService),
    );
  }
}

class AddTownshipDialog extends StatefulWidget {
  const new({super.key, required this.townshipService});

  final TownshipService townshipService;

  @override
  State<AddTownshipDialog> createState() => _AddTownshipDialogState();
}

class _AddTownshipDialogState extends State<AddTownshipDialog> {
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
              Scanner(
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

    final townshipName = _textController.text.trim();

    try {
      setState(() {
        _loading = true;
      });

      await widget.townshipService.addTownship(townshipName, _pictureBytes!);

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
