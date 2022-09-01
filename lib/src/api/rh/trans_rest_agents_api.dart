// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:http/http.dart' as http;

class TransRestAgentsApi {
  var client = http.Client();

  Future<List<TransRestAgentsModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(transRestAgentsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<TransRestAgentsModel> data = [];
      for (var u in bodyList) {
        data.add(TransRestAgentsModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<TransRestAgentsModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/rh/trans-rest-agents/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return TransRestAgentsModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<TransRestAgentsModel> insertData(
      TransRestAgentsModel transRest) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = transRest.toJson();
    var body = jsonEncode(data);

    var res =
        await client.post(addTransRestAgentsUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return TransRestAgentsModel.fromJson(json.decode(res.body));
    } else if (res.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(transRest);
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<TransRestAgentsModel> updateData(
      TransRestAgentsModel transRest) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = transRest.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/rh/trans-rest-agents/update-trans-rest-agent/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return TransRestAgentsModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/rh/trans-rest-agents/delete-trans-rest-agent/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
