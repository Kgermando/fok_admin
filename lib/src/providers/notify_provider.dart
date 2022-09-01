import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/notify/notify_model.dart';
import 'package:flutter/material.dart';

class NotifyProvider extends ChangeNotifier {
  NotifyModel notifyList = const NotifyModel(count: 0);

  bool idToken = false;

  // void get notifyData async {
  //   notifyList = await SalaireNotifyApi().getCountBudget();
  //   notifyListeners();
  // }

  Future<bool> get isDarkMode async {
    String? id = await UserSharedPref().getIdToken();
    if (id != "") {
      idToken = true;
      notifyListeners();
      return idToken;
    } else {
      idToken = false;
      notifyListeners();
      return idToken;
    }
  }
}
