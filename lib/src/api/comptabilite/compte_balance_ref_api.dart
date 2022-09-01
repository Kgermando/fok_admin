// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comptabilites/balance_comptes_model.dart';
import 'package:http/http.dart' as http;

class CompteBalanceRefApi {
  var client = http.Client();
  Future<List<CompteBalanceRefModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(balanceCompteRefUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CompteBalanceRefModel> data = [];
      for (var u in bodyList) {
        data.add(CompteBalanceRefModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CompteBalanceRefModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/comptabilite/comptes-balance-ref/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CompteBalanceRefModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CompteBalanceRefModel> insertData(
      CompteBalanceRefModel balanceCompteModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = balanceCompteModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addBalanceCompteRefUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CompteBalanceRefModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(balanceCompteModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CompteBalanceRefModel> updateData(
      CompteBalanceRefModel balanceCompteModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = balanceCompteModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/comptabilite/comptes-balance-ref/update-comptes-balance-ref/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CompteBalanceRefModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/comptabilite/comptes-balance-ref/delete-comptes-balance-ref/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
