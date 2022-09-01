// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:http/http.dart' as http;

class StockGlobalApi {
  var client = http.Client();

  Future<List<StocksGlobalMOdel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(stockGlobalUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<StocksGlobalMOdel> data = [];
      for (var u in bodyList) {
        data.add(StocksGlobalMOdel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<StocksGlobalMOdel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/stocks-global/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return StocksGlobalMOdel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<StocksGlobalMOdel> insertData(
      StocksGlobalMOdel stocksGlobalMOdel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = stocksGlobalMOdel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addStockGlobalUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return StocksGlobalMOdel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(stocksGlobalMOdel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<StocksGlobalMOdel> updateData(
      StocksGlobalMOdel stocksGlobalMOdel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = stocksGlobalMOdel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/stocks-global/update-stocks-global/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return StocksGlobalMOdel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/stocks-global/delete-stocks-global/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
