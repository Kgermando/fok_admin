// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:http/http.dart' as http;

class PresenceApi {
  var client = http.Client();

  Future<List<PresenceModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(listPresenceUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<PresenceModel> data = [];
      for (var u in bodyList) {
        data.add(PresenceModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<PresenceModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/rh/presences/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return PresenceModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<PresenceModel> insertData(PresenceModel presenceModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = presenceModel.toJson();
    var body = jsonEncode(data);

    var res = await client.post(addPresenceUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return PresenceModel.fromJson(json.decode(res.body));
    } else if (res.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(presenceModel);
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<PresenceModel> updateData(PresenceModel presenceModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = presenceModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/rh/presences/update-presence/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return PresenceModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/rh/presences/delete-presence/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
