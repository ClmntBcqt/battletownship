import 'package:flutter/material.dart';
import 'package:frontend/widgets/help/help_dialog.dart';

class HelpButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            shape: .circle,
          ),
          child: IconButton.outlined(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => HelpDialog(),
            ),
            icon: Icon(Icons.question_mark),
          ),
        ),
      ),
    );
  }
}
