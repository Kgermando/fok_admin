// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:http/http.dart' as http;

class MobilierApi {
  var client = http.Client();

  Future<List<MobilierModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(mobiliersUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<MobilierModel> data = [];
      for (var u in bodyList) {
        data.add(MobilierModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<MobilierModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/mobiliers/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return MobilierModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<MobilierModel> insertData(MobilierModel anguinModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = anguinModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addMobiliersUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return MobilierModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(anguinModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<MobilierModel> updateData(MobilierModel anguinModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = anguinModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/mobiliers/update-mobilier/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return MobilierModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/mobiliers/delete-mobilier/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
