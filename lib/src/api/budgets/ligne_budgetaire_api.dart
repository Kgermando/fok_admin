// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:http/http.dart' as http;

class LIgneBudgetaireApi {
  var client = http.Client();

  Future<List<LigneBudgetaireModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(ligneBudgetairesUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<LigneBudgetaireModel> data = [];
      for (var u in bodyList) {
        data.add(LigneBudgetaireModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<LigneBudgetaireModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/budgets/ligne-budgetaires/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return LigneBudgetaireModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<LigneBudgetaireModel> insertData(
      LigneBudgetaireModel ligneBudgetaireModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = ligneBudgetaireModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addbudgetLigneBudgetairesUrl,
        headers: header, body: body);
    if (resp.statusCode == 200) {
      return LigneBudgetaireModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(ligneBudgetaireModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<LigneBudgetaireModel> updateData(
      int id, LigneBudgetaireModel ligneBudgetaireModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = ligneBudgetaireModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/budgets/ligne-budgetaires/update-ligne-budgetaire/$id");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return LigneBudgetaireModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/budgets/ligne-budgetaires/delete-ligne-budgetaire/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
