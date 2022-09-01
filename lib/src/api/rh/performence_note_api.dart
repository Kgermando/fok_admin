// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:http/http.dart' as http;

class PerformenceNoteApi {
  var client = http.Client();

  Future<List<PerformenceNoteModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var res = await client.get(listPerformenceNoteUrl, headers: header);

    if (res.statusCode == 200) {
      List<dynamic> bodyList = json.decode(res.body);
      List<PerformenceNoteModel> data = [];
      for (var u in bodyList) {
        data.add(PerformenceNoteModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<PerformenceNoteModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/rh/performences-note/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return PerformenceNoteModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PerformenceNoteModel> insertData(
      PerformenceNoteModel performenceModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = performenceModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addPerformenceNoteUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return PerformenceNoteModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(performenceModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PerformenceNoteModel> updateData(
      PerformenceNoteModel performenceModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = performenceModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/rh/performences-note/update-performence-note/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return PerformenceNoteModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/rh/performences-note/delete-performence-note/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
