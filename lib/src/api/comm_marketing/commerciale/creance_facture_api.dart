// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:http/http.dart' as http;

class CreanceFactureApi {
  var client = http.Client();

  Future<List<CreanceCartModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(factureCreancesUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CreanceCartModel> data = [];
      for (var u in bodyList) {
        data.add(CreanceCartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CreanceCartModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/facture-creances/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CreanceCartModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CreanceCartModel> insertData(CreanceCartModel creanceCartModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = creanceCartModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addFactureCreancesUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CreanceCartModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(creanceCartModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CreanceCartModel> updateData(CreanceCartModel creanceCartModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = creanceCartModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/facture-creances/update-facture-creance/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CreanceCartModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/facture-creances/delete-facture-creance/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
