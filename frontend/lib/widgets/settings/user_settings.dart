import 'package:flutter/material.dart';
import 'package:frontend/dtos/user_infos.dart';
import 'package:frontend/widgets/settings/setting_section_title.dart';
import 'package:frontend/widgets/settings/setting_tile.dart';

class UserSettings extends StatelessWidget {
  const new({super.key, required this._userInfos});

  final UserInfos _userInfos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 16,
      children: [
        SettingSectionTitle(title: "Compte"),
        SettingTile(
          route: "/settings/user",
          child: Row(
            spacing: 16,
            children: [
              CircleAvatar(child: Icon(Icons.person)),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    _userInfos.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    _userInfos.email,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
