import 'package:flutter/material.dart';
import 'package:frontend/services/scans_service.dart';
import 'package:frontend/widgets/scans/header_card.dart';
import 'package:frontend/widgets/scans/scan_card.dart';
import 'package:provider/provider.dart';

class ScanList extends StatelessWidget {
  const new({super.key});
  @override
  Widget build(BuildContext context) {
    final scans = context.watch<ScanService>().myScans;
    return Column(
      spacing: 16,
      children: [
        HeaderCard(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => context.read<ScanService>().fetchMyScans(),
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: scans.length,
              itemBuilder: (context, index) {
                var scan = scans[index];
                return ScanCard(scan: scan);
              },
            ),
          ),
        ),
      ],
    );
  }
}
