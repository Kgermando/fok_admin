// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/notify/notify_model.dart';
import 'package:http/http.dart' as http;

class AgendaNotifyApi extends ChangeNotifier {
  var client = http.Client();

  Future<NotifyModel> getCount(String matricule) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$agendasNotifyUrl/get-count/$matricule");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return getCount(matricule);
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
