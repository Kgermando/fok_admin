// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:http/http.dart' as http;

class TransportRestaurationApi {
  var client = http.Client();

  Future<List<TransportRestaurationModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(transportRestaurationUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<TransportRestaurationModel> data = [];
      for (var u in bodyList) {
        data.add(TransportRestaurationModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<TransportRestaurationModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/rh/transport-restaurations/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return TransportRestaurationModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<TransportRestaurationModel> insertData(
      TransportRestaurationModel transRest) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = transRest.toJson();
    var body = jsonEncode(data);

    var res = await client.post(addTransportRestaurationUrl,
        headers: header, body: body);
    if (res.statusCode == 200) {
      return TransportRestaurationModel.fromJson(json.decode(res.body));
    } else if (res.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(transRest);
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<TransportRestaurationModel> updateData(
      TransportRestaurationModel transRest) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = transRest.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/rh/transport-restaurations/update-transport-restauration/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return TransportRestaurationModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/rh/transport-restaurations/delete-transport-restauration/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
