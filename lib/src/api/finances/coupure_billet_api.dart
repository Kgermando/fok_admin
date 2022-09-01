// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/finances/coupure_billet_model.dart';
import 'package:http/http.dart' as http;

class CoupureBilletApi {
  var client = http.Client();

  Future<List<CoupureBilletModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(coupureBilletUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CoupureBilletModel> data = [];
      for (var u in bodyList) {
        data.add(CoupureBilletModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CoupureBilletModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/finances/coupure-billets/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CoupureBilletModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CoupureBilletModel> insertData(
      CoupureBilletModel coupureBillet) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = coupureBillet.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addCoupureBilleUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CoupureBilletModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(coupureBillet);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CoupureBilletModel> updateData(
      CoupureBilletModel coupureBillet) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = coupureBillet.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/finances/coupure-billets/update-coupure-billet/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CoupureBilletModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/finances/coupure-billets/delete-coupure-billet/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
