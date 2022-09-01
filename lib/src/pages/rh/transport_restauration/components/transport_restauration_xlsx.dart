import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class TransportRestXlsx {
  Future<void> exportToExcel(List<TransportRestaurationModel> dataList) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Transport & Restauration'];
    sheetObject.insertRowIterables([
      "id",
      "title",
      "observation",
      "signature",
      "created",
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
        dataList[i].observation,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
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
        dataList[i].ligneBudgetaire
      ];

      sheetObject.insertRowIterables(data, i + 1);
    }
    excel.setDefaultSheet('Transport & Restauration');
    final dir = await getApplicationDocumentsDirectory();
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);

    var onValue = excel.encode();
    File('${dir.path}/transport_restauration$date.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
  }
}
