// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_bilan_ref_model.dart';
import 'package:http/http.dart' as http;

class CompteBilanRefApi {
  var client = http.Client();
  Future<List<CompteBilanRefModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(compteBilanRefUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CompteBilanRefModel> data = [];
      for (var u in bodyList) {
        data.add(CompteBilanRefModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CompteBilanRefModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/comptabilite/comptes-bilans-ref/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CompteBilanRefModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CompteBilanRefModel> insertData(CompteBilanRefModel bilanModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = bilanModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addCompteBilanRefUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CompteBilanRefModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(bilanModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CompteBilanRefModel> updateData(CompteBilanRefModel bilanModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = bilanModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/comptabilite/comptes-bilans-ref/update-compte-bilan-ref/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CompteBilanRefModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/comptabilite/comptes-bilans-ref/delete-compte-bilan-ref/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
