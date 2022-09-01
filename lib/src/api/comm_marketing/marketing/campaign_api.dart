// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:http/http.dart' as http;

class CampaignApi {
  var client = http.Client();

  Future<List<CampaignModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(campaignsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CampaignModel> data = [];
      for (var u in bodyList) {
        data.add(CampaignModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CampaignModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/campaigns/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CampaignModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CampaignModel> insertData(CampaignModel campaignModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = campaignModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addCampaignsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CampaignModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(campaignModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CampaignModel> updateData(CampaignModel campaignModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = campaignModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/campaigns/update-campaign/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CampaignModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/campaigns/delete-campaign/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
