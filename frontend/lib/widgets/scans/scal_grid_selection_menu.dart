import 'package:flutter/material.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:provider/provider.dart';

class ScanGridSelectionMenu extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scanService = context.read<ScanService>();
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        FilledButton.icon(
          label: Text("${scanService.selectionCount}"),
          icon: Icon(Icons.close),
          onPressed: () => scanService.clearSelection(),
        ),

        Row(
          spacing: 8,
          children: [
            IconButton.filledTonal(
              onPressed: () => scanService.toogleAllSelection(),
              icon: Icon(Icons.select_all),
            ),
            MenuAnchor(
              animated: true,
              menuChildren: [
                MenuItemButton(
                  leadingIcon: Icon(Icons.delete),
                  child: Text("Supprimer"),
                  onPressed: () async =>
                      await showDeletionConfirmationDialog(context),
                ),
              ],
              builder: (_, controller, _) => IconButton.filledTonal(
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                icon: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> showDeletionConfirmationDialog(
    BuildContext context,
  ) => showDialog(
    context: context,
    builder: (context) {
      final scanService = context.read<ScanService>();
      final count = scanService.selectionCount;
      return AlertDialog(
        title: Text("Êtes vous sûr ?"),
        content: Text(
          "Cette action supprimera définitivement $count scan${count > 1 ? "s" : ""}. Il${count > 1 ? "s ne pourrons" : " ne pourra"} pas être récupéré${count > 1 ? "s" : ""}.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler"),
          ),
          FilledButton(
            onPressed: () async {
              await scanService.deleteSelection();
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: Text("Ok"),
          ),
        ],
      );
    },
  );
}
