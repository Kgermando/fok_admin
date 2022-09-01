// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/notify/notify_sum_model.dart';
import 'package:http/http.dart' as http;

class LogistiqueDepartementNotifyApi extends ChangeNotifier {
  var client = http.Client();

  var logistiqueUrl = Uri.parse(
      "$logistiqueDepartementNotifyUrl/get-count-departement-logistique/");

  Future<NotifySumModel> getCountLogistique() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(logistiqueUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
