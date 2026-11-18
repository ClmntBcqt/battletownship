import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/settings/user_update_form.dart';
import 'package:provider/provider.dart';

class SettingsUserPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    var userInfos = context.watch<AuthService>().userInfo;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: userInfos,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                return UserUpdateForm(userInfos: asyncSnapshot.data!);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      appBar: AppBar(title: Text("Compte")),
    );
  }
}
