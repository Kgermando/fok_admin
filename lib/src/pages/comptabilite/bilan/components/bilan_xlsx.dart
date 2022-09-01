import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class BilanXlsx {
  Future<void> exportToExcel(List<BilanModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Bilans";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "titleBilan",
      "signature",
      "created",
      "isSubmit",
      "approbationDG",
      "motifDG",
      "signatureDG",
      "approbationDD",
      "motifDD",
      "signatureDD"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].titleBilan,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
        dataList[i].isSubmit,
        dataList[i].approbationDG,
        dataList[i].motifDG,
        dataList[i].signatureDG,
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
