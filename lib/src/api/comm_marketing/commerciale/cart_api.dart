// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:http/http.dart' as http;

class CartApi {
  var client = http.Client();

  Future<List<CartModel>> getAllData(String matricule) async {
    Map<String, String> header = await HeaderHttp().header();

    var cartsUrl = Uri.parse("$mainUrl/carts/$matricule");
    var resp = await client.get(cartsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CartModel> data = [];
      for (var u in bodyList) {
        data.add(CartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CartModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/carts/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CartModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CartModel> insertData(CartModel cartModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = cartModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addCartsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CartModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(cartModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CartModel> updateData(CartModel cartModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = cartModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/carts/update-cart/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CartModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/carts/delete-cart/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteAllData(String signature) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl = Uri.parse("$mainUrl/carts/delete-all-cart/$signature");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
