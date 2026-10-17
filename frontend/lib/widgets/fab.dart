import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/township_service.dart';
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
    return FloatingActionButton(
      onPressed: () => showAddTownshipPopup(context, townshipService),
      child: Icon(Icons.add),
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
  new({super.key, required this.townshipService});

  final TownshipService townshipService;
  final textController = TextEditingController();

  @override
  State<AddTownshipDialog> createState() => _AddTownshipDialogState();
}

class _AddTownshipDialogState extends State<AddTownshipDialog> {
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ajouter une commune"),
      content: TextField(
        controller: widget.textController,
        decoration: InputDecoration(hint: Text("Nom"), errorText: error),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (loading) return;
            if (widget.textController.text.trim().isEmpty) return;
            final name = widget.textController.text.trim();
            try {
              setState(() {
                loading = true;
              });
              await widget.townshipService.addTownship(name);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            } on DioException catch (e) {
              setState(() {
                error = e.response?.data['detail'];
              });
            } finally {
              setState(() {
                loading = false;
              });
            }
          },
          child: loading ? CircularProgressIndicator() : Text("Ok"),
        ),
      ],
    );
  }
}
