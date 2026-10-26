import 'package:flutter/material.dart';
import 'package:frontend/widgets/shared/eb10_sign.dart';

class HelpDialog extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Bienvenue sur BattleTownship !"),
      content: Column(
        mainAxisSize: .min,
        spacing: 16,
        children: [
          Text(
            "Votre but : collectionner des communes partout en France !\n\n"
            "Pour cela, vous devrez scanner les panneaux d'agglomérations, "
            "mais attention, celui qui possède la commune est le dernier à l'avoir scanné ! "
            "Serez-vous un grand collectionneur, ou un chapardeur de commune ? \n\n"
            "Soyez vigilant, car votre photo sera visible partout, "
            "et votre scan sera supprimé si il est trop signalé. "
            "Ici, ce sont les joueurs qui s'auto-modèrent. "
            "La règle : le panneau de la commune scannée (référence EB10 et EB20) "
            "doit être visible sur votre photo.",
            softWrap: true,
          ),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.titleLarge!,
            child: EB10Sign(text: "Bon jeu !"),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Ok"),
        ),
      ],
    );
  }
}
