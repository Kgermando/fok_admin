// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/logistiques/immobilier_model.dart';
import 'package:http/http.dart' as http;

class ImmobilierApi {
  var client = http.Client();

  Future<List<ImmobilierModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(immobiliersUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ImmobilierModel> data = [];
      for (var u in bodyList) {
        data.add(ImmobilierModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<ImmobilierModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/immobiliers/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return ImmobilierModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ImmobilierModel> insertData(ImmobilierModel anguinModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = anguinModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addImmobiliersUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return ImmobilierModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(anguinModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ImmobilierModel> updateData(ImmobilierModel anguinModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = anguinModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/immobiliers/update-immobilier/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return ImmobilierModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/immobiliers/delete-immobilier/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
