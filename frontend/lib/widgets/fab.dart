import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/scanner/scanner_dialog.dart';
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
    var townshipService = context.read<ApiService>();
    return FloatingActionButton.large(
      onPressed: () => showAddTownshipPopup(context, townshipService),
      child: Icon(Icons.add),
    );
  }

  Future<void> showAddTownshipPopup(
    BuildContext context,
    ApiService townshipService,
  ) {
    return showDialog<String>(
      context: context,
      builder: (context) => ScannerDialog(townshipService: townshipService),
    );
  }
}
