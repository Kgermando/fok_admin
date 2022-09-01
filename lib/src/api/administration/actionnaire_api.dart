// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_model.dart';
import 'package:http/http.dart' as http;

class ActionnaireApi {
  var client = http.Client();

  Future<List<ActionnaireModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(actionnaireListUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ActionnaireModel> data = [];
      for (var u in bodyList) {
        data.add(ActionnaireModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ActionnaireModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/admin/actionnaires/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return ActionnaireModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ActionnaireModel> insertData(ActionnaireModel actionnaireModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = actionnaireModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(actionnaireAddUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return ActionnaireModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(actionnaireModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ActionnaireModel> updateData(ActionnaireModel actionnaireModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = actionnaireModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/admin/actionnaires/update-actionnaire/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return ActionnaireModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/admin/actionnaires/delete-actionnaire/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
