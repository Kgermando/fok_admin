// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/history_ravitaillement_model.dart';
import 'package:http/http.dart' as http;

class HistoryRavitaillementApi {
  var client = http.Client();

  Future<List<HistoryRavitaillementModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(historyRavitaillementsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<HistoryRavitaillementModel> data = [];
      for (var u in bodyList) {
        data.add(HistoryRavitaillementModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<HistoryRavitaillementModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/history-ravitaillements/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return HistoryRavitaillementModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<HistoryRavitaillementModel> insertData(
      HistoryRavitaillementModel historyRavitaillementModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = historyRavitaillementModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addHistoryRavitaillementsUrl,
        headers: header, body: body);
    if (resp.statusCode == 200) {
      return HistoryRavitaillementModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(historyRavitaillementModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<HistoryRavitaillementModel> updateData(
      HistoryRavitaillementModel historyRavitaillementModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = historyRavitaillementModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/history-ravitaillements/update-history-ravitaillement/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return HistoryRavitaillementModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/history-ravitaillements/delete-history-ravitaillement/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
