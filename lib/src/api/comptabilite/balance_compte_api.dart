// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comptabilites/balance_comptes_model.dart';
import 'package:http/http.dart' as http;

class BalanceCompteApi {
  var client = http.Client();

  Future<List<BalanceCompteModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(balanceComptessUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<BalanceCompteModel> data = [];
      for (var u in bodyList) {
        data.add(BalanceCompteModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<BalanceCompteModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/comptabilite/balance_comptes/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return BalanceCompteModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<BalanceCompteModel> insertData(
      BalanceCompteModel balanceCompteModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = balanceCompteModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addBalanceComptesUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return BalanceCompteModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(balanceCompteModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<BalanceCompteModel> updateData(
      BalanceCompteModel balanceCompteModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = balanceCompteModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/comptabilite/balance_comptes/update-balance-compte/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return BalanceCompteModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/comptabilite/balance_comptes/delete-balance-compte/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
