import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class MobilierXlsx {
  Future<void> exportToExcel(List<MobilierModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Mobiliers";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "nom",
      "modele",
      "marque",
      "descriptionMobilier",
      "nombre",
      "signature",
      "created",
      "approbationDD",
      "motifDD",
      "signatureDD"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].nom,
        dataList[i].modele,
        dataList[i].marque,
        dataList[i].descriptionMobilier,
        dataList[i].nombre,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
        dataList[i].approbationDD,
        dataList[i].motifDD,
        dataList[i].signatureDD,
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
