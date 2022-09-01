import 'dart:convert';

import 'package:fokad_admin/src/helpers/user_shared_pref.dart';

class HeaderHttp {
  Future<Map<String, String>> header() async {
    String? token = await UserSharedPref().getAccessToken();

    if (token!.isNotEmpty) {
      var splittedJwt = token.split(".");
      // ignore: unused_local_variable
      var payload = json.decode(
          ascii.decode(base64.decode(base64.normalize(splittedJwt[1]))));
    }

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    return headers;
  }
}
