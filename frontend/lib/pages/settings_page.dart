import 'package:flutter/material.dart';
import 'package:frontend/dtos/user_infos.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/settings/user_settings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfos = context.read<AuthService>().userInfo;
    return SafeArea(
      minimum: .only(left: 16, right: 16, top: 16),
      child: FutureBuilder<UserInfos>(
        future: userInfos,
        builder: (_, snapshot) => snapshot.hasData
            ? UserSettings(userInfos: snapshot.data!)
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
