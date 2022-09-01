// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:http/http.dart' as http;

class SuccursaleApi {
  var client = http.Client();

  Future<List<SuccursaleModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(succursalesUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<SuccursaleModel> data = [];
      for (var u in bodyList) {
        data.add(SuccursaleModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<SuccursaleModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/succursales/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return SuccursaleModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<SuccursaleModel> insertData(SuccursaleModel succursaleModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = succursaleModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addSuccursalesUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return SuccursaleModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(succursaleModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<SuccursaleModel> updateData(SuccursaleModel succursaleModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = succursaleModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/succursales/update-succursale/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return SuccursaleModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/succursales/delete-succursale/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
