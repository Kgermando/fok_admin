// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/devis/devis_list_objets_model.dart';
import 'package:http/http.dart' as http;

class DevisListObjetsApi {
  var client = http.Client();
  Future<List<DevisListObjetsModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(devisListObjetUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<DevisListObjetsModel> data = [];
      for (var u in bodyList) {
        data.add(DevisListObjetsModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<DevisListObjetsModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/devis-list-objets/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return DevisListObjetsModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<DevisListObjetsModel> insertData(
      DevisListObjetsModel devisModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = devisModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(adddevisListObjetUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return DevisListObjetsModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(devisModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<DevisListObjetsModel> updateData(
      DevisListObjetsModel devisModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = devisModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/devis-list-objets/update-devis-list-objet/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return DevisListObjetsModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/devis-list-objets/delete-devis-list-objet/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
