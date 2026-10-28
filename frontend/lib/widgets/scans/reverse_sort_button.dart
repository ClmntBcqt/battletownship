import 'package:flutter/material.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:provider/provider.dart';

class ReverseSortButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scanService = context.watch<ScanService>();
    return ElevatedButton(
      onPressed: () => scanService.reverseSort(),
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 40),
      ),
      child: Icon(
        scanService.isSortReversed ? Icons.arrow_upward : Icons.arrow_downward,
      ),
    );
  }
}
