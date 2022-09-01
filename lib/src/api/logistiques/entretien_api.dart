// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart';
import 'package:http/http.dart' as http;

class EntretienApi {
  var client = http.Client();

  Future<List<EntretienModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(entretiensUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<EntretienModel> data = [];
      for (var u in bodyList) {
        data.add(EntretienModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<EntretienModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/entretiens/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return EntretienModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<EntretienModel> insertData(EntretienModel entretienModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = entretienModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addEntretiensUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return EntretienModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(entretienModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<EntretienModel> updateData(EntretienModel entretienModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = entretienModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/entretiens/update-entretien/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return EntretienModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/entretiens/delete-entretien/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
