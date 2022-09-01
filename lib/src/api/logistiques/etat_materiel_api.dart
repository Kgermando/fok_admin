// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/charts/pie_chart_model.dart';
import 'package:fokad_admin/src/models/logistiques/etat_materiel_model.dart';
import 'package:http/http.dart' as http;

class EtatMaterielApi {
  var client = http.Client();

  Future<List<EtatMaterielModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(etatMaterielUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<EtatMaterielModel> data = [];
      for (var u in bodyList) {
        data.add(EtatMaterielModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<EtatMaterielModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/etat_materiels/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return EtatMaterielModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<EtatMaterielModel> insertData(
      EtatMaterielModel etatMaterielModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = etatMaterielModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addEtatMaterielUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return EtatMaterielModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(etatMaterielModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<EtatMaterielModel> updateData(
      EtatMaterielModel etatMaterielModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = etatMaterielModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/etat_materiels/update-etat-materiel/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return EtatMaterielModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/etat_materiels/delete-etat-materiel/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<PieChartMaterielModel>> getChartPieStatut() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(etatMaterieChartPielUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<PieChartMaterielModel> data = [];
      for (var row in bodyList) {
        data.add(PieChartMaterielModel.fromJson(row));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }
}
