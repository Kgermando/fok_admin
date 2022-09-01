import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/logistiques/carburant_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CarburantXlsx {
  Future<void> exportToExcel(List<CarburantModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Carburants";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "operationEntreSortie",
      "typeCaburant",
      "fournisseur",
      "nomeroFactureAchat",
      "prixAchatParLitre",
      "nomReceptioniste",
      "numeroPlaque",
      "dateHeureSortieAnguin",
      "qtyAchat",
      "signature",
      "created",
      "approbationDD",
      "motifDD",
      "signatureDD"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].operationEntreSortie,
        dataList[i].typeCaburant,
        dataList[i].fournisseur,
        dataList[i].nomeroFactureAchat,
        dataList[i].prixAchatParLitre,
        dataList[i].nomReceptioniste,
        dataList[i].numeroPlaque,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].dateHeureSortieAnguin),
        dataList[i].qtyAchat,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
        dataList[i].approbationDD,
        dataList[i].motifDD,
        dataList[i].signatureDD
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
