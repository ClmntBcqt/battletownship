import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/dtos/login_request.dart';
import 'package:frontend/dtos/register_request.dart';
import 'package:frontend/dtos/update_user_request.dart';
import 'package:frontend/dtos/user_infos.dart';
import 'package:frontend/services/api_client.dart';

class AuthService extends ChangeNotifier {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  UserInfos? _userInfos;

  Future<void> register(String email, String username, String password) async {
    await _apiClient.register(
      RegisterRequest(email: email, username: username, password: password),
    );

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await _apiClient.login(LoginRequest(email: email, password: password));

    notifyListeners();
  }

  Future<UserInfos> get userInfo async =>
      _userInfos ?? (_userInfos = await _apiClient.getUserInfos());

  Future<bool> get isAuthenticated async {
    try {
      var _ = await userInfo;
      return true;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        return false;
      }
      rethrow;
    }
  }

  Future<void> updateUser(
    String email,
    String username,
    String currentPassword,
    String? newPassword,
  ) async {
    await _apiClient.updateUser(
      UpdateUserRequest(
        email: email,
        username: username,
        newPassword: newPassword,
        currentPassword: currentPassword,
      ),
    );

    _userInfos = null;

    notifyListeners();
  }
}
