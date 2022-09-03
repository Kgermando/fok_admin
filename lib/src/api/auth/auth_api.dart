// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fokad_admin/src/api/auth/api_error.dart';
import 'package:fokad_admin/src/api/auth/token.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:http/http.dart' as http;

class AuthApi extends ChangeNotifier {
  var client = http.Client();

  Future<bool> login(String matricule, String passwordHash) async {
    var data = {'matricule': matricule, 'passwordHash': passwordHash};
    var body = jsonEncode(data);

    var resp = await client.post(loginUrl, body: body);
    if (resp.statusCode == 200) {
      Token token = Token.fromJson(json.decode(resp.body));
      // Store the tokens
      UserSharedPref().saveIdToken(token.id.toString()); // Id user
      UserSharedPref().saveAccessToken(token.accessToken);
      UserSharedPref().saveRefreshToken(token.refreshToken);
      return true;
    } else {
      // throw ApiError.fromJson(json.decode(resp.body));
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    String? accessToken = await UserSharedPref().getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> refreshAccessToken() async {
    Map<String, String> header = await HeaderHttp().header();

    // final refreshToken = await storage.read(key: 'refreshToken');
    String? refreshToken = await UserSharedPref().getRefreshToken();
    if (refreshToken!.isNotEmpty) {
      var splittedJwt = refreshToken.split(".");
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }
    var data = {'refresh_token': refreshToken};
    var body = jsonEncode(data);
    var resp = await client.post(
      refreshTokenUrl,
      body: body,
      headers: header,
    );
    if (resp.statusCode == 200) {
      Token token = Token.fromJson(json.decode(resp.body));
      UserSharedPref().saveAccessToken(token.accessToken);
      UserSharedPref().saveRefreshToken(token.refreshToken);
    } else {
      UserSharedPref().removeAccessToken();
      UserSharedPref().removeRefreshToken();
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  // A timer to refresh the access token one minute before it expires
  refreshAccessTokenTimer(int time) async {
    var newTime = time - 60000; // Renew 1min before it expires
    await Future.delayed(Duration(milliseconds: newTime));

    try {
      await refreshAccessToken();
    } catch (e) {
      // await refreshAccessToken();
      refreshAccessTokenTimer(time);
      debugPrint('un soucis $e');
    }
  }

  Future<UserModel> getUserInfo() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(userUrl, headers: header);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<UserModel> getUserId() async {
    Map<String, String> header = await HeaderHttp().header();
    String? data = await UserSharedPref().getIdToken();
    var idPrefs = (data != "") ? jsonDecode(data!) : "0";
    int id = 0;
    if (idPrefs != '') {
      id = int.parse(idPrefs);
    }
    var userIdUrl = Uri.parse("$mainUrl/user/$id");
    var resp = await client.get(userIdUrl, headers: header);
    if (resp.statusCode == 200) { 
      return UserModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 404) {
      return UserModel(
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
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<void> logout() async {
    Map<String, String> header = await HeaderHttp().header();
    try {
      var resp = await client.post(
        logoutUrl,
        headers: header,
      );
      if (resp.statusCode == 200) {}
    } catch (e) {
      throw Exception(['message']);
    }
  }
}
