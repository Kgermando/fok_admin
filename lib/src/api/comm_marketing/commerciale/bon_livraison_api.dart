// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/bon_livraison.dart';
import 'package:http/http.dart' as http;

class BonLivraisonApi {
  var client = http.Client();

  Future<List<BonLivraisonModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(bonLivraisonsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<BonLivraisonModel> data = [];
      for (var u in bodyList) {
        data.add(BonLivraisonModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<BonLivraisonModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/bon-livraisons/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return BonLivraisonModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<BonLivraisonModel> insertData(
      BonLivraisonModel bonLivraisonModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = bonLivraisonModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addBonLivraisonsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return BonLivraisonModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(bonLivraisonModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<BonLivraisonModel> updateData(
      BonLivraisonModel bonLivraisonModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = bonLivraisonModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/bon-livraisons/update-bon-livraison/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return BonLivraisonModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/bon-livraisons/delete-bon-livraison/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
