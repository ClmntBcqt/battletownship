import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const new({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  void clearAllFields() {
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();
  }

  bool _isRegisterMode = false;

  bool _hidePassword = true;

  String? _emailError;
  void resetEmailError() => setState(() {
    _emailError = null;
  });

  String? _usernameError;
  void resetUsernameError() => setState(() {
    _usernameError = null;
  });

  List<String> _generalError = [];
  void resetGeneralError() => setState(() {
    _generalError = [];
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            spacing: 16,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  label: Text("Email"),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: Validators.validateEmail,
                autovalidateMode: .onUnfocus,
                forceErrorText: _emailError,
                onChanged: (_) => resetEmailError(),
                errorBuilder: errorBuilder,
              ),
              if (_isRegisterMode)
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    label: Text("Nom d'utilisateur"),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: Validators.validateUsername,
                  autovalidateMode: .onUnfocus,
                  forceErrorText: _usernameError,
                  onChanged: (_) => resetUsernameError(),
                  errorBuilder: errorBuilder,
                ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  label: Text("Mot de passe"),
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _hidePassword = !_hidePassword;
                    }),
                    icon: Icon(
                      _hidePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: _hidePassword,
                validator: Validators.validatePassword,
                autovalidateMode: .onUnfocus,
                errorBuilder: errorBuilder,
              ),

              if (_generalError.isNotEmpty)
                Row(
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    Flexible(
                      child: Text(
                        _generalError.join(", "),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: .topCenter,
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: switchMode,
                  child: Text(_isRegisterMode ? "Se connecter" : "S'inscrire"),
                ),
                FilledButton(
                  onPressed: () async => _isRegisterMode
                      ? await sendRegister()
                      : await sendLogin(),
                  child: Text(
                    _isRegisterMode ? "Créer un compte" : "Connexion",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget errorBuilder(BuildContext context, String errorText) =>
      Text(errorText, softWrap: true);

  Future<void> sendRegister() async {
    final authService = context.read<AuthService>();

    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (Validators.validateEmail(email) != null ||
        Validators.validateUsername(username) != null ||
        Validators.validatePassword(password) != null) {
      return;
    }

    try {
      await authService.register(email, username, password);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final isEmailConflictError =
            (e.response!.data['errors']['DuplicateEmail'] as List<dynamic>)
                .isNotEmpty;
        if (isEmailConflictError) {
          setState(() {
            _emailError = "Un compte avec cet email existe déjà";
          });
        }

        final isUsernameConflictError =
            (e.response!.data['errors']['DuplicateUserName'] as List<dynamic>)
                .isNotEmpty;
        if (isUsernameConflictError) {
          setState(() {
            _usernameError = "Ce nom d'utilisateur est déjà pris";
          });
        }

        setState(() {
          _generalError = e.response!.data['errors']['other'];
        });
      } else {
        rethrow;
      }

      clearAllFields();

      if (!mounted) return;
      context.go("/map");
    }
  }

  Future<void> sendLogin() async {
    final authService = context.read<AuthService>();

    final email = _emailController.text;
    final password = _passwordController.text;

    if (Validators.validateEmail(email) != null ||
        Validators.validatePassword(password) != null) {
      return;
    }

    try {
      await authService.login(email, password);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        setState(() {
          _generalError = [e.response!.data['detail']];
        });
      } else {
        rethrow;
      }
    }

    clearAllFields();

    if (!mounted) return;
    context.go("/map");
  }

  void switchMode() {
    resetEmailError();
    resetUsernameError();
    resetGeneralError();

    setState(() {
      _isRegisterMode = !_isRegisterMode;
    });
  }
}
