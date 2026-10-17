import 'package:flutter/material.dart';
import 'package:frontend/services/township_service.dart';
import 'package:provider/provider.dart';

class Fab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    var townshipService = context.read<TownshipService>();
    return FloatingActionButton(
      onPressed: () => addTownShip(context, townshipService),
      child: Icon(Icons.add),
    );
  }

  Future<void> addTownShip(
    BuildContext context,
    TownshipService townshipService,
  ) async {
    String? name = await showAddTownshipPopup(context);

    if (name == null) return;

    townshipService.addTownship(name);
  }

  Future<String?> showAddTownshipPopup(BuildContext context) {
    final textController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ajouter une commune"),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hint: Text("Nom")),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(
              textController.text.trim().isNotEmpty
                  ? textController.text.trim()
                  : null,
            ),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }
}
