// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/logistiques/objet_remplace_model.dart';
import 'package:http/http.dart' as http;

class ObjetRemplaceApi {
  var client = http.Client();

  Future<List<ObjetRemplaceModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(objetsRemplaceUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ObjetRemplaceModel> data = [];
      for (var u in bodyList) {
        data.add(ObjetRemplaceModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<ObjetRemplaceModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/objets-remplaces/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return ObjetRemplaceModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ObjetRemplaceModel> insertData(
      ObjetRemplaceModel objetRemplaceModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = objetRemplaceModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addobjetsRemplaceUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return ObjetRemplaceModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(objetRemplaceModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ObjetRemplaceModel> updateData(
      ObjetRemplaceModel objetRemplaceModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = objetRemplaceModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/objets-remplaces/update-objet-remplace/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return ObjetRemplaceModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/objets-remplaces/delete-objet-remplace/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
