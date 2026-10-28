import 'package:flutter/material.dart';
import 'package:frontend/widgets/scans/filter_bar.dart';
import 'package:frontend/widgets/scans/reverse_sort_button.dart';
import 'package:frontend/widgets/scans/sorting_menu.dart';

class HeaderCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Expanded(child: FilterBar()),

        Row(children: [SortingMenu(), ReverseSortButton()]),
      ],
    );
  }
}
