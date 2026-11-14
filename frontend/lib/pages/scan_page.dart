import 'package:flutter/material.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:frontend/widgets/scans/scan_grid.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatefulWidget {
  const new({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(left: 16, right: 16, bottom: 8, top: 64),
      child: FutureBuilder(
        future: context.read<ScanService>().fetchMyScans(),
        builder: (context, snapshot) {
          return snapshot.connectionState == .done
              ? ScanGrid()
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
