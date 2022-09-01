import 'dart:io';

import 'package:fokad_admin/src/models/comptabilites/journal_livre_model.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class JournalXlsx {
  Future<void> exportToExcel(List<JournalLivreModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Journals";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "intitule",
      "debut",
      "fin",
      "signature",
      "created",
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].intitule,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].debut),
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].fin),
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
