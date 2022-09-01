// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/charts/courbe_chart_model.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:http/http.dart' as http;

class CaisseApi {
  var client = http.Client();

  Future<List<CaisseModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(caisseUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CaisseModel> data = [];
      for (var u in bodyList) {
        data.add(CaisseModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CaisseModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/finances/transactions/caisses/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CaisseModel> insertData(CaisseModel caisseModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = caisseModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addCaisseUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(caisseModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CaisseModel> updateData(CaisseModel caisseModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = caisseModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/finances/transactions/caisses/update-transaction-caisse/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/finances/transactions/caisses/delete-transaction-caisse/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<CourbeChartModel>> getAllDataMouthEncaissement() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(caisseEncaissementMouthUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeChartModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeChartModel>> getAllDataMouthDecaissement() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(caisseDecaissementMouthUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeChartModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeChartModel>> getAllDataYearEncaissement() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(caisseEncaissementYearUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeChartModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeChartModel>> getAllDataYearDecaissement() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(caisseDecaissementYearUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeChartModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }
}
