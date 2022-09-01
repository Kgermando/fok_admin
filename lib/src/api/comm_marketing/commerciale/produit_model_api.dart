// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:http/http.dart' as http;

class ProduitModelApi {
  var client = http.Client();

  Future<List<ProductModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(prodModelsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ProductModel> data = [];
      for (var u in bodyList) {
        data.add(ProductModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<ProductModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/produit-models/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return ProductModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ProductModel> insertData(ProductModel productModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = productModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addProdModelsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return ProductModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(productModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ProductModel> updateData(ProductModel productModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = productModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/produit-models/update-produit-model/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return ProductModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/produit-models/delete-produit-model/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
