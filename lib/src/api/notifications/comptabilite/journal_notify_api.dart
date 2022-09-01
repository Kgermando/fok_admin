// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/notify/notify_model.dart';
import 'package:http/http.dart' as http;

class JournalNotifyApi extends ChangeNotifier {
  var client = http.Client();

  var getDGUrl = Uri.parse("$journalsNotifyUrl/get-count-dg/");
  var getDDUrl = Uri.parse("$journalsNotifyUrl/get-count-dd/");

  Future<NotifyModel> getCountDG() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(getDGUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return getCountDG();
    } else {
      throw Exception(resp.statusCode);
    }
  }

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
}
