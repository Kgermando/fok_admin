// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:http/http.dart' as http;

class JournalApi {
  var client = http.Client();

  Future<List<JournalModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(journalsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<JournalModel> data = [];
      for (var u in bodyList) {
        data.add(JournalModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<JournalModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/comptabilite/journals/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return JournalModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<JournalModel> insertData(JournalModel journalModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = journalModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addjournalsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return JournalModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(journalModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<JournalModel> updateData(JournalModel journalModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = journalModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/comptabilite/journals/update-journal/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return JournalModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/comptabilite/journals/delete-journal/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  // Future<List<CourbeJournalModel>> getAllDataJournalMouth() async {
  //   Map<String, String> header = await HeaderHttp().header();

  //   var resp = await client.get(journalsChartMounthUrl, headers: header);

  //   if (resp.statusCode == 200) {
  //     List<dynamic> bodyList = json.decode(resp.body);
  //     List<CourbeJournalModel> data = [];
  //     for (var u in bodyList) {
  //       data.add(CourbeJournalModel.fromJson(u));
  //     }
  //     return data;
  //   } else {
  //     throw Exception(resp.statusCode);
  //   }
  // }

  // Future<List<CourbeJournalModel>> getAllDataJournalYear() async {
  //   Map<String, String> header = await HeaderHttp().header();

  //   var resp = await client.get(journalsChartYearUrl, headers: header);

  //   if (resp.statusCode == 200) {
  //     List<dynamic> bodyList = json.decode(resp.body);
  //     List<CourbeJournalModel> data = [];
  //     for (var u in bodyList) {
  //       data.add(CourbeJournalModel.fromJson(u));
  //     }
  //     return data;
  //   } else {
  //     throw Exception(resp.statusCode);
  //   }
  // }
}
