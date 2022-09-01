import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/users/user_model.dart';

class UserSharedPref extends ChangeNotifier {
  static const _keyUser = 'userModel'; 
  static const _keyIdToken = 'idToken';
  static const _keyAccessToken = 'accessToken';
  static const _keyRefreshToken = 'refreshToken';

  // Init storage
  final storage = const FlutterSecureStorage();

  Future<UserModel> read() async {
    final prefs = await storage.read(key: _keyUser);
    if (prefs != null) {
      UserModel user = UserModel.fromJson(jsonDecode(prefs));
      return user;
    } else {
      UserModel user = UserModel(
          nom: '-',
          prenom: '-',
          email: '-',
          telephone: '-',
          matricule: '-',
          departement: '-',
          servicesAffectation: '-',
          fonctionOccupe: '-',
          role: '5',
          isOnline: 'false',
          createdAt: DateTime.now(),
          passwordHash: '-',
          succursale: '-');
      return user;
    }
  }

  saveUser(value) async {
    await storage.write(key: _keyUser, value: json.encode(value));
  }

  removeUser() async {
    await storage.delete(key: _keyUser);
  }

  // ID User
  Future<String?> getIdToken() async { 
    final data = await storage.read(key: _keyIdToken);
    if (data != null) {
      return data;
    } else {
      return "";
    }
  }

  saveIdToken(value) async {
    await storage.write(key: _keyIdToken, value: json.encode(value));
  }

  removeIdToken() async {
    await storage.delete(key: _keyIdToken);
  }

  // AccessToken
  Future<String?> getAccessToken() async {
    final data = await storage.read(key: _keyAccessToken);

    if (data != null) {
      return data;
    } else { 
      return "";
    }
  }

  saveAccessToken(value) async {
    await storage.write(key: _keyAccessToken, value: json.encode(value));
  }

  removeAccessToken() async {
    await storage.delete(key: _keyAccessToken);
  }

  // RefreshToken
  Future<String?> getRefreshToken() async {
    final data = await storage.read(key: _keyRefreshToken);
    return data;
  }

  saveRefreshToken(value) async {
    await storage.write(key: _keyRefreshToken, value: json.encode(value));
  }

  removeRefreshToken() async {
    await storage.delete(key: _keyRefreshToken);
  }
}
