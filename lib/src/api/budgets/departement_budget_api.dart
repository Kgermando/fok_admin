// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:http/http.dart' as http;

class DepeartementBudgetApi {
  var client = http.Client();

  Future<List<DepartementBudgetModel>> getAllData() async {
    // Map<String, String> header = await HeaderHttp().header();
    Map<String, String> header = await HeaderHttp().header();
    var resp = await client.get(budgetDepartementsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<DepartementBudgetModel> data = [];
      for (var u in bodyList) {
        data.add(DepartementBudgetModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<DepartementBudgetModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/budgets/departements/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return DepartementBudgetModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<DepartementBudgetModel> insertData(
      DepartementBudgetModel departementBudgetModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = departementBudgetModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addBudgetDepartementsUrl,
        headers: header, body: body);
    if (resp.statusCode == 200) {
      return DepartementBudgetModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(departementBudgetModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<DepartementBudgetModel> updateData(
      DepartementBudgetModel departementBudgetModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = departementBudgetModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/budgets/departements/update-departement-budget/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return DepartementBudgetModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/budgets/departements/delete-departement-budget/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
