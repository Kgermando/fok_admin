// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/notify/notify_model.dart';
import 'package:http/http.dart' as http;

class SalaireNotifyApi extends ChangeNotifier {
  var client = http.Client();

  var getDDUrl = Uri.parse("$salairesNotifyUrl/get-count-dd/");
  var getBudgetUrl = Uri.parse("$salairesNotifyUrl/get-count-budget/");
  var getFinUrl = Uri.parse("$salairesNotifyUrl/get-count-fin/");
  var getObsUrl = Uri.parse("$salairesNotifyUrl/get-count-obs/");

  Future<NotifyModel> getCountDD() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(getDDUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return getCountDD();
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifyModel> getCountBudget() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(getBudgetUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return getCountBudget();
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifyModel> getCountFin() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(getFinUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return getCountFin();
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifyModel> getCountObs() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(getObsUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return getCountObs();
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
