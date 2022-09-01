import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ActionnaireXlsx {
  Future<void> exportToExcel(List<ActionnaireModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Actionnaires";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "nom",
      "postNom",
      "prenom",
      "email",
      "telephone",
      "adresse",
      "sexe",
      "matricule",
      "signature",
      "created"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].nom,
        dataList[i].postNom,
        dataList[i].prenom,
        dataList[i].email,
        dataList[i].telephone,
        dataList[i].adresse,
        dataList[i].sexe,
        dataList[i].matricule,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
      ];

      sheetObject.insertRowIterables(data, i + 1);
    }
    excel.setDefaultSheet(title);
    final dir = await getApplicationDocumentsDirectory();
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);

    var onValue = excel.encode();
    File('${dir.path}/$title$date.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
  }
}
