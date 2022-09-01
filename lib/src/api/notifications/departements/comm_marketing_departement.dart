// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/notify/notify_sum_model.dart';
import 'package:http/http.dart' as http;

class ComMarketingDepartementNotifyApi extends ChangeNotifier {
  var client = http.Client();

  var comMarketingUrl = Uri.parse(
      "$commMarketingDepartementNotifyUrl/get-count-departement-comm-marketing/");

  Future<NotifySumModel> getCountComMarketing() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(comMarketingUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
