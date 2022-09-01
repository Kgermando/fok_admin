// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/update/update_model.dart';
import 'package:http/http.dart' as http;

class UpdateVersionApi {
  var client = http.Client();

  Future<List<UpdateModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(updateVerionUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<UpdateModel> data = [];
      for (var u in bodyList) {
        data.add(UpdateModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<UpdateModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/update-versions/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return UpdateModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<UpdateModel> insertData(UpdateModel updateModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = updateModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addUpdateVerionrUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return UpdateModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(updateModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<UpdateModel> updateData(UpdateModel updateModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = updateModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/update-versions/update-update-version/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return UpdateModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/update-versions/delete-update-verion/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
