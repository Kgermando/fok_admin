// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/notify/notify_sum_model.dart';
import 'package:http/http.dart' as http;

class ComptabiliteDepartementNotifyApi extends ChangeNotifier {
  var client = http.Client();

  var comptabiliteUrl = Uri.parse(
      "$comptabiliteDepartementNotifyUrl/get-count-departement-comptabilite/");

  Future<NotifySumModel> getCountComptabilite() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(comptabiliteUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
