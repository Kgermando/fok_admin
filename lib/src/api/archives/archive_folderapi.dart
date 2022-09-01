// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fokad_admin/src/api/header_http.dart';
import 'package:fokad_admin/src/api/route_api.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:http/http.dart' as http;

class ArchiveFolderApi {
  var client = http.Client();

  Future<List<ArchiveFolderModel>> getAllData() async {
    Map<String, String> header = await HeaderHttp().header();

    var resp = await client.get(archveFoldersUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ArchiveFolderModel> data = [];
      for (var u in bodyList) {
        data.add(ArchiveFolderModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ArchiveFolderModel> getOneData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var getUrl = Uri.parse("$mainUrl/archives-folders/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return ArchiveFolderModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ArchiveFolderModel> insertData(ArchiveFolderModel archiveModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = archiveModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addArchveFolderUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return ArchiveFolderModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(archiveModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ArchiveFolderModel> updateData(ArchiveFolderModel archiveModel) async {
    Map<String, String> header = await HeaderHttp().header();

    var data = archiveModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/archives-folders/update-archive-folder/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return ArchiveFolderModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = await HeaderHttp().header();

    var deleteUrl =
        Uri.parse("$mainUrl/archives-folders/delete-archive-folder/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
