import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class BanqueXlsx {
  Future<void> exportToExcel(List<BanqueModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Banque";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "nomComplet",
      "pieceJustificative",
      "libelle",
      "montant",
      "departement",
      "typeOperation",
      "numeroOperation",
      "signature",
      "created"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].nomComplet,
        dataList[i].pieceJustificative,
        dataList[i].libelle,
        dataList[i].montant,
        dataList[i].departement,
        dataList[i].typeOperation,
        dataList[i].numeroOperation,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created)
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
