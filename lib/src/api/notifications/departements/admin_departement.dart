// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/notify/notify_sum_model.dart';
import 'package:http/http.dart' as http;

class AdminDepartementNotifyApi extends ChangeNotifier {
  var client = http.Client();

  var budgetUrl = Uri.parse(
      "$adminDepartementNotifyUrl/get-count-admin-departement-budget/");
  var comMarketingUrl = Uri.parse(
      "$adminDepartementNotifyUrl/get-count-admin-departement-comm-marketing/");
  var comptabiliteUrl = Uri.parse(
      "$adminDepartementNotifyUrl/get-count-admin-departement-comptabilite/");
  var exploitationUrl = Uri.parse(
      "$adminDepartementNotifyUrl/get-count-admin-departement-exploitation/");
  var financeUrl = Uri.parse(
      "$adminDepartementNotifyUrl/get-count-admin-departement-finance/");
  var logistiqueUrl = Uri.parse(
      "$adminDepartementNotifyUrl/get-count-admin-departement-logistique/");
  var rhUrl =
      Uri.parse("$adminDepartementNotifyUrl/get-count-admin-departement-rh/");
  var devisUrl = Uri.parse(
      "$adminDepartementNotifyUrl/get-count-admin-departement-devis/");

  Future<NotifySumModel> getCountBudget() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(budgetUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifySumModel> getCountComMarketing() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(comMarketingUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifySumModel> getCountComptabilite() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(comptabiliteUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifySumModel> getCountFinance() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(financeUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifySumModel> getCountExploitation() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(exploitationUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifySumModel> getCountLogistique() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(logistiqueUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifySumModel> getCountRh() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(rhUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<NotifySumModel> getCountDevis() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(devisUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifySumModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
