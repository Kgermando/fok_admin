// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/charts/pie_chart_model.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:http/http.dart' as http;

class AnguinApi {
  var client = http.Client();

  Future<List<AnguinModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(anguinsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AnguinModel> data = [];
      for (var u in bodyList) {
        data.add(AnguinModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<AnguinModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/anguins/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return AnguinModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AnguinModel> insertData(AnguinModel anguinModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = anguinModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(aaddAnguinsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return AnguinModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(anguinModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AnguinModel> updateData(AnguinModel anguinModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = anguinModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/anguins/update-anguin/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return AnguinModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/anguins/delete-anguin/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<PieChartEnguinModel>> getChartPie() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(anguinsChartPieUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<PieChartEnguinModel> data = [];
      for (var row in bodyList) {
        data.add(PieChartEnguinModel.fromJson(row));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }
}
