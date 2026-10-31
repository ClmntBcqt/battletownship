import 'package:flutter/material.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:frontend/widgets/scans/scal_grid_selection_menu.dart';
import 'package:frontend/widgets/scans/scan_grid_header.dart';
import 'package:frontend/widgets/scans/scan_cell.dart';
import 'package:provider/provider.dart';

class ScanGrid extends StatelessWidget {
  const new({super.key});
  @override
  Widget build(BuildContext context) {
    final scanService = context.watch<ScanService>();
    final scans = scanService.myScans;
    return Column(
      spacing: 16,
      children: [
        scanService.isSelectionEmpty
            ? ScanGridHeader()
            : ScanGridSelectionMenu(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => context.read<ScanService>().fetchMyScans(),
            child: GridView.extent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 1.1,
              children: scans.map((s) => ScanCell(scan: s)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
