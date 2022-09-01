// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/restitution_model.dart';
import 'package:http/http.dart' as http;

class RestitutionApi {
  var client = http.Client();

  Future<List<RestitutionModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(restitutionsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<RestitutionModel> data = [];
      for (var u in bodyList) {
        data.add(RestitutionModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<RestitutionModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/restitutions/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return RestitutionModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<RestitutionModel> insertData(RestitutionModel restitutionModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = restitutionModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addRestitutionsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return RestitutionModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(restitutionModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<RestitutionModel> updateData(RestitutionModel restitutionModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = restitutionModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/restitutions/update-restitution/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return RestitutionModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/restitutions/delete-restitution/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
