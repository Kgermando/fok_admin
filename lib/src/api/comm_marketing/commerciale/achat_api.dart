// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:http/http.dart' as http;

class AchatApi {
  var client = http.Client();

  Future<List<AchatModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(achatsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AchatModel> data = [];
      for (var u in bodyList) {
        data.add(AchatModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<AchatModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/achats/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return AchatModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<AchatModel> insertData(AchatModel achatModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = achatModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addAchatsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return AchatModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(achatModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<AchatModel> updateData(AchatModel achatModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = achatModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/achats/update-achat/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return AchatModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/achats/delete-achat/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
