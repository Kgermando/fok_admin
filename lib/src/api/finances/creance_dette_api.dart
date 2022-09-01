// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/finances/creance_dette_model.dart';
import 'package:http/http.dart' as http;

class CreanceDetteApi {
  var client = http.Client();
  Future<List<CreanceDetteModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(creacneDetteUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CreanceDetteModel> data = [];
      for (var u in bodyList) {
        data.add(CreanceDetteModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CreanceDetteModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/finances/creance-dettes/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CreanceDetteModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CreanceDetteModel> insertData(
      CreanceDetteModel creanceDetteModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = creanceDetteModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(creacneDetteAddUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CreanceDetteModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(creanceDetteModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CreanceDetteModel> updateData(
      CreanceDetteModel creanceDetteModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = creanceDetteModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/finances/update-creance-dette/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CreanceDetteModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/finances/delete-creance-dette/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
