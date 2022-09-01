// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_livre_model.dart';
import 'package:http/http.dart' as http;

class JournalLivreApi {
  var client = http.Client();

  Future<List<JournalLivreModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(journalsLivreUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<JournalLivreModel> data = [];
      for (var u in bodyList) {
        data.add(JournalLivreModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<JournalLivreModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/comptabilite/journals-livres/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return JournalLivreModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<JournalLivreModel> insertData(JournalLivreModel journalModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = journalModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addjournalsLivreUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return JournalLivreModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(journalModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<JournalLivreModel> updateData(JournalLivreModel journalModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = journalModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/comptabilite/journals-livres/update-journal-livre/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return JournalLivreModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/comptabilite/journals-livres/delete-journal-livre/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
