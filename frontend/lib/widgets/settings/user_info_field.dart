import 'package:flutter/material.dart';

class UserInfoField extends StatelessWidget {
  const new({
    super.key,
    required this._controller,
    required this._label,
    required this._icon,
    this._validator,
    this._obscureText = false,
    this._autofillHints = const [],
    this._error,
    this.onChanged,
  });

  final TextEditingController _controller;
  final String _label;
  final IconData _icon;
  final String? Function(String?)? _validator;
  final bool _obscureText;
  final List<String> _autofillHints;
  final String? _error;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(spacing: 8, children: [Icon(_icon), Text(_label)]),
        TextFormField(
          controller: _controller,
          validator: _validator,
          autovalidateMode: .onUserInteraction,
          forceErrorText: _error,
          errorBuilder: (_, errorText) => Text(errorText, softWrap: true),
          obscureText: _obscureText,
          autofillHints: _autofillHints,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
