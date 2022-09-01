// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:http/http.dart' as http;

class AgendaApi {
  var client = http.Client();

  Future<List<AgendaModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(agendasUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AgendaModel> data = [];
      for (var u in bodyList) {
        data.add(AgendaModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<AgendaModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/agendas/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return AgendaModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AgendaModel> insertData(AgendaModel agendaModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = agendaModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addAgendasUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return AgendaModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(agendaModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AgendaModel> updateData(AgendaModel agendaModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = agendaModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/agendas/update-agenda/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return AgendaModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/agendas/delete-agenda/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
