import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/dtos/user_infos.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/validators.dart';
import 'package:frontend/widgets/settings/confirm_password_dialog.dart';
import 'package:frontend/widgets/settings/user_info_field.dart';
import 'package:provider/provider.dart';

class UserUpdateForm extends StatefulWidget {
  const new({super.key, required this._userInfos});

  final UserInfos _userInfos;

  @override
  State<UserUpdateForm> createState() => _UserUpdateFormState();
}

class _UserUpdateFormState extends State<UserUpdateForm> {
  late final _emailController = TextEditingController(
    text: widget._userInfos.email,
  );
  late final _usernameController = TextEditingController(
    text: widget._userInfos.username,
  );
  late final _newPasswordController = TextEditingController();
  late final _newPasswordConfirmationController = TextEditingController();

  String? _emailError;
  String? _usernameError;
  String? _newPasswordError;
  String? _newPasswordConfirmationError;
  String? _otherError;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: .symmetric(horizontal: 0, vertical: 48),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 32,
                  crossAxisAlignment: .start,
                  children: [
                    UserInfoField(
                      controller: _emailController,
                      label: "Adresse e-mail",
                      icon: Icons.email,
                      validator: Validators.validateEmail,
                      autofillHints: [AutofillHints.email],
                      error: _emailError,
                      onChanged: (_) => setState(() {
                        _otherError = null;
                        _emailError = null;
                      }),
                    ),

                    UserInfoField(
                      controller: _usernameController,
                      label: "Nom d'utilisateur",
                      icon: Icons.person,
                      validator: Validators.validateUsername,
                      autofillHints: [AutofillHints.newUsername],
                      error: _usernameError,
                      onChanged: (_) => setState(() {
                        _otherError = null;
                        _usernameError = null;
                      }),
                    ),

                    UserInfoField(
                      controller: _newPasswordController,
                      label: "Nouveau mot de passe",
                      icon: Icons.lock,
                      validator: Validators.validatePassword,
                      obscureText: true,
                      autofillHints: [AutofillHints.newPassword],
                      error: _newPasswordError,
                      onChanged: (_) => setState(() {
                        _otherError = null;
                        _newPasswordError = null;
                      }),
                    ),
                    UserInfoField(
                      controller: _newPasswordConfirmationController,
                      label: "Confirmez le nouveau mot de passe",
                      icon: Icons.lock,
                      validator: (passwordConfirmation) =>
                          Validators.validatePasswordConfirmation(
                            _newPasswordController.text,
                            passwordConfirmation,
                          ),
                      obscureText: true,
                      autofillHints: [AutofillHints.newPassword],
                      error: _newPasswordConfirmationError,
                      onChanged: (_) => setState(() {
                        _otherError = null;
                        _newPasswordConfirmationError = null;
                      }),
                    ),

                    if (_otherError != null)
                      Row(
                        mainAxisSize: .min,
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.error,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          Flexible(
                            child: Text(
                              _otherError!,
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
            ),

            Align(
              alignment: .centerEnd,
              child: OutlinedButton.icon(
                onPressed: () async => await updateUser(context),
                icon: Icon(Icons.save),
                label: Text("Sauvegarder"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateUser(BuildContext context) async {
    var email = _emailController.text.trim();
    var username = _usernameController.text.trim();
    var newPassword = _newPasswordController.text.isNotEmpty
        ? _newPasswordController.text
        : null;
    var newPasswordConfirmation =
        _newPasswordConfirmationController.text.isNotEmpty
        ? _newPasswordConfirmationController.text
        : null;

    if (!hasInfoChanged(email, username, newPassword)) return;

    if (!validateForm(email, username, newPassword, newPasswordConfirmation)) {
      return;
    }

    String? currentPassword;

    currentPassword = await showDialog<String?>(
      context: context,
      builder: (_) => ConfirmPasswordDialog(),
    );

    if (currentPassword == null) {
      return;
    }

    if (!context.mounted) return;
    var authService = context.read<AuthService>();

    try {
      await authService.updateUser(
        email,
        username,
        currentPassword,
        newPassword,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        setState(() {
          _otherError = "Une erreur est survenue. Les modification n'ont pas été appliquées.";
        });
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

        final isOtherError =
            (e.response!.data['errors']['other'] as List<dynamic>).isNotEmpty;
        if (isOtherError) {
          setState(() {
            _otherError = (e.response!.data['errors']['other'] as List<dynamic>)
                .join(" ");
          });
        }
        return;
      }
      if (e.response?.statusCode == 403) {
        setState(() {
          _otherError = "Mot de passe incorrect";
        });
        return;
      }
      rethrow;
    }
  }

  bool validateForm(
    String email,
    String username,
    String? newPassword,
    String? newPasswordConfirmation,
  ) {
    setState(() {
      _emailError = Validators.validateEmail(email);
      _usernameError = Validators.validateUsername(username);
      _newPasswordError = newPassword != null
          ? Validators.validatePassword(newPassword)
          : null;
      _newPasswordConfirmationError = newPassword != null
          ? Validators.validatePasswordConfirmation(
              newPassword,
              newPasswordConfirmation,
            )
          : null;
    });

    return (_emailError ??
            _usernameError ??
            _newPasswordError ??
            _newPasswordConfirmationError) ==
        null;
  }

  bool hasInfoChanged(String email, String username, String? newPassword) {
    return email != widget._userInfos.email ||
        username != widget._userInfos.username ||
        newPassword != null;
  }
}
