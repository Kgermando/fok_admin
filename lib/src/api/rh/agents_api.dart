// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/rh/agent_count_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:http/http.dart' as http;

class AgentsApi extends ChangeNotifier {
  var client = http.Client();

  Future<AgentCountModel> getCount() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(agentCountUrl, headers: header);

    if (resp.statusCode == 200) {
      return AgentCountModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return getCount();
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<AgentModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(listAgentsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AgentModel> data = [];
      for (var u in bodyList) {
        data.add(AgentModel.fromJson(u));
      }
      notifyListeners();
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<AgentModel>> getAllSearch(String query) async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(listAgentsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);

      return bodyList.map((json) => AgentModel.fromJson(json)).where((data) {
        final nomLower = data.nom.toLowerCase();
        final postNomLower = data.postNom.toLowerCase();
        final matriculeLower = data.matricule.toLowerCase();
        final sexeLower = data.sexe.toLowerCase();
        final searchLower = query.toLowerCase();

        return nomLower.contains(searchLower) ||
            postNomLower.contains(searchLower) ||
            matriculeLower.contains(searchLower) ||
            sexeLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<AgentModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/rh/agents/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return AgentModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<AgentPieChartModel>> getChartPieSexe() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(agentChartPieSexeUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AgentPieChartModel> data = [];
      for (var row in bodyList) {
        data.add(AgentPieChartModel.fromJson(row));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<AgentModel> insertData(AgentModel agentModel) async {
    Map<String, String> header = await HeaderHttp().header();
    var data = agentModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addAgentsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return AgentModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(agentModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<AgentModel> updateData(AgentModel agentModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = agentModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/rh/agents/update-agent/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return AgentModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/rh/agents/delete-agent/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
