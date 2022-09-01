// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/charts/courbe_chart_model.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:http/http.dart' as http;

class BanqueApi {
  var client = http.Client();
  Future<List<BanqueModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(banqueUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<BanqueModel> data = [];
      for (var u in bodyList) {
        data.add(BanqueModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<BanqueModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/finances/transactions/banques/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return BanqueModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<BanqueModel> insertData(BanqueModel banqueModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = banqueModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addBanqueUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return BanqueModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(banqueModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<BanqueModel> updateData(BanqueModel banqueModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = banqueModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/finances/transactions/banques/update-transaction-banque/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return BanqueModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse(
        "$mainUrl/finances/transactions/banques/delete-transaction-banque/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<CourbeChartModel>> getAllDataMouthDepot() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(banqueDepotMouthUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeChartModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeChartModel>> getAllDataMouthRetrait() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(banqueRetraitMountUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeChartModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeChartModel>> getAllDataYearDepot() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(banqueDepotYearUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeChartModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeChartModel>> getAllDataYearRetrait() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(banqueRetraitYeartUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeChartModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }
}
