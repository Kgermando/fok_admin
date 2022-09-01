// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:http/http.dart' as http;

class PaiementSalaireApi {
  var client = http.Client();

  Future<List<PaiementSalaireModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(listPaiementSalaireUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<PaiementSalaireModel> data = [];
      for (var u in bodyList) {
        data.add(PaiementSalaireModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementSalaireModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/rh/paiement-salaires/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return PaiementSalaireModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementSalaireModel> insertData(
      PaiementSalaireModel paiementSalaireModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = paiementSalaireModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addPaiementSalaireUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return PaiementSalaireModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(paiementSalaireModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementSalaireModel> updateData(
      PaiementSalaireModel paiementSalaireModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = paiementSalaireModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/rh/paiement-salaires/update-paiement/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return PaiementSalaireModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/rh/paiement-salaires/delete-paiement/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
