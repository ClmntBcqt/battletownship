import 'package:flutter/material.dart';

class ConfirmPasswordDialog extends StatefulWidget {
  const new({super.key});

  @override
  State<ConfirmPasswordDialog> createState() => _ConfirmPasswordDialogState();
}

class _ConfirmPasswordDialogState extends State<ConfirmPasswordDialog> {
  final _passwordController = TextEditingController();
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmer ?"),
      content: Column(
        mainAxisSize: .min,
        children: [
          Text(
            "Confirmez votre mot de passe actuel pour mettre à jour des informations sensibles",
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(icon: Icon(Icons.lock)),
            autofillHints: [AutofillHints.password],
            obscureText: true,
            forceErrorText: _passwordError,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Annuler"),
        ),
        FilledButton(
          onPressed: () {
            var password = _passwordController.text;
            if (password.isEmpty) {
              setState(() {
                _passwordError = "Le mot de passe est requis";
              });
              return;
            }
            Navigator.of(context).pop(password);
          },
          child: Text("Ok"),
        ),
      ],
    );
  }
}
