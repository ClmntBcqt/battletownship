import 'package:flutter/material.dart';
import 'package:frontend/widgets/help/help_button.dart';
import 'package:frontend/widgets/map/map.dart';

class MapPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [MapWidget(), HelpButton()]);
  }
}
