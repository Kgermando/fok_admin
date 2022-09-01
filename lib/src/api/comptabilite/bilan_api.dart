// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:http/http.dart' as http;

class BilanApi {
  var client = http.Client();

  Future<List<BilanModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(bilansUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<BilanModel> data = [];
      for (var u in bodyList) {
        data.add(BilanModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<BilanModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/comptabilite/bilans/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return BilanModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<BilanModel> insertData(BilanModel bilanModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = bilanModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addbilansUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return BilanModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(bilanModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<BilanModel> updateData(BilanModel banqueModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = banqueModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/comptabilite/bilans/update-bilan/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return BilanModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/comptabilite/bilans/delete-bilan/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
