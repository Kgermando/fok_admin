// ignore_for_file: unused_local_variable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:http/http.dart' as http;

class DevisAPi extends ChangeNotifier {
  var client = http.Client();
  Future<List<DevisModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(devisUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<DevisModel> data = [];
      for (var u in bodyList) {
        data.add(DevisModel.fromJson(u));
      }
      notifyListeners();
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<DevisModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/devis/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return DevisModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<DevisModel> insertData(DevisModel devisModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = devisModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addDevissUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return DevisModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(devisModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<DevisModel> updateData(DevisModel devisModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = devisModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/devis/update-devis/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return DevisModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/devis/delete-devis/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
