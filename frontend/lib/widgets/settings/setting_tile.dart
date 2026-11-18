import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingTile extends StatelessWidget {
  const new({super.key, required this.child, this.route});

  final Widget child;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: .circular(16),
      onTap: () => route != null ? context.push(route!) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            child,
            if (route != null) Icon(Icons.keyboard_arrow_right, size: 32),
          ],
        ),
      ),
    );
  }
}
