import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AnnuaireXlsx {
  Future<void> exportToExcel(List<AnnuaireModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Annuaire";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "categorie",
      "nomPostnomPrenom",
      "email",
      "mobile1",
      "mobile2",
      "secteurActivite",
      "nomEntreprise",
      "grade",
      "adresseEntreprise",
      "succursale",
      "signature",
      "created"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].categorie,
        dataList[i].nomPostnomPrenom,
        dataList[i].email,
        dataList[i].mobile1,
        dataList[i].mobile2,
        dataList[i].secteurActivite,
        dataList[i].nomEntreprise,
        dataList[i].grade,
        dataList[i].adresseEntreprise,
        dataList[i].succursale,
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
