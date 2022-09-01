// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/logistiques/trajet_model.dart';
import 'package:http/http.dart' as http;

class TrajetApi {
  var client = http.Client();

  Future<List<TrajetModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(trajetsUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<TrajetModel> data = [];
      for (var u in bodyList) {
        data.add(TrajetModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<TrajetModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/trajets/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return TrajetModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<TrajetModel> insertData(TrajetModel trajetModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = trajetModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addTrajetssUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return TrajetModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(trajetModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<TrajetModel> updateData(TrajetModel trajetModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = trajetModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/trajets/update-trajet/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return TrajetModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/trajets/delete-trajet/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
