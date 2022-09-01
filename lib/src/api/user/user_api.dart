// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:http/http.dart' as http;

class UserApi {
  var client = http.Client();

  Future<List<UserModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(userAllUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<UserModel> data = [];
      for (var u in bodyList) {
        data.add(UserModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<UserModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var userUrl = Uri.parse("$mainUrl/user/$id");
    var resp = await client.get(userUrl, headers: header);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<UserModel> insertData(UserModel userModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = userModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(registerUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(userModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<UserModel> updateData(UserModel userModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = userModel.toJson();
    var body = jsonEncode(data);
    var updateAgentsUrl = Uri.parse("$mainUrl/user/update-user/");

    var resp = await client.put(updateAgentsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<UserModel> changePassword(UserModel userModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = userModel.toJson();
    var body = jsonEncode(data);
    var updateAgentsUrl = Uri.parse("$mainUrl/user/change-password/");

    var resp = await client.put(updateAgentsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteAgentsUrl = Uri.parse("$mainUrl/user/delete-user/$id");
    var res = await client.delete(deleteAgentsUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
