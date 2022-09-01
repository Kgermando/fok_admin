// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/notify/notify_sum_model.dart';
import 'package:http/http.dart' as http;

class FinanceDepartementNotifyApi extends ChangeNotifier {
  var client = http.Client();

  var financeDDUrl =
      Uri.parse("$financesDepartementNotifyUrl/get-count-departement-finance/");
  var financeObsUrl = Uri.parse(
      "$financesDepartementNotifyUrl/get-count-departement-finance-obs/");

  Future<NotifySumModel> getCountFinanceDD() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(financeDDUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifySumModel> getCountFinanceObs() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(financeObsUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
