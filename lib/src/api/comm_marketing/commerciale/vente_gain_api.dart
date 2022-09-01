// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/courbe_vente_gain_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_chart_model.dart';
import 'package:http/http.dart' as http;

class VenteGainApi {
  var client = http.Client();

  Future<List<VenteChartModel>> getVenteChart() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(venteChartsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<VenteChartModel> data = [];
      for (var u in bodyList) {
        data.add(VenteChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeVenteModel>> getAllDataVenteMouth() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(venteChartMonthsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeVenteModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeVenteModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<CourbeVenteModel>> getAllDataVenteYear() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(venteChartYearsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeVenteModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeVenteModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeGainModel>> getAllDataGainMouth() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(gainChartMonthsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeGainModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeGainModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.body);
    }
  }

  Future<List<CourbeGainModel>> getAllDataGainYear() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(gainChartYearsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeGainModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeGainModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }
}
