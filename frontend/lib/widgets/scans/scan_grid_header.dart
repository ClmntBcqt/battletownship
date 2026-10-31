import 'package:flutter/material.dart';
import 'package:frontend/widgets/scans/filter_bar.dart';
import 'package:frontend/widgets/scans/sorting_menu.dart';

class ScanGridHeader extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Expanded(child: FilterBar()),

        SortingMenu(),
      ],
    );
  }
}
