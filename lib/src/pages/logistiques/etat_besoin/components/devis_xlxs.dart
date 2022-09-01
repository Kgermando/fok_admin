import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DevisXlsx {
  Future<void> exportToExcel(List<DevisModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Etats de besoin";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "title",
      "priority",
      "departement",
      "observation",
      "signature",
      "created",
      "isSubmit",
      "approbationDG",
      "motifDG",
      "signatureDG",
      "approbationBudget",
      "motifBudget",
      "signatureBudget",
      "approbationFin",
      "motifFin",
      "signatureFin",
      "approbationDD",
      "motifDD",
      "signatureDD",
      "ligneBudgetaire",
      "ressource"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].title,
        dataList[i].priority,
        dataList[i].departement,
        dataList[i].observation,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
        dataList[i].isSubmit,
        dataList[i].approbationDG,
        dataList[i].motifDG,
        dataList[i].signatureDG,
        dataList[i].approbationBudget,
        dataList[i].motifBudget,
        dataList[i].signatureBudget,
        dataList[i].approbationFin,
        dataList[i].motifFin,
        dataList[i].signatureFin,
        dataList[i].approbationDD,
        dataList[i].motifDD,
        dataList[i].signatureDD,
        dataList[i].ligneBudgetaire,
        dataList[i].ressource
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
