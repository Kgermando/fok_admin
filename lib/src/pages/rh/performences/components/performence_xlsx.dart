import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class PerformenceXlsx {
  Future<void> exportToExcel(List<PerformenceModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Performences";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "agent",
      "departement",
      "nom",
      "postnom",
      "prenom",
      "signature",
      "Date"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].agent,
        dataList[i].departement,
        dataList[i].nom,
        dataList[i].postnom,
        dataList[i].prenom,
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
