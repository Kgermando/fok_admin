import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/logistiques/trajet_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class TrajetXlsx {
  Future<void> exportToExcel(List<TrajetModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Carburants";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "nomeroEntreprise",
      "nomUtilisateur",
      "trajetDe",
      "trajetA",
      "mission",
      "kilometrageSorite",
      "kilometrageRetour",
      "signature",
      "created",
      "approbationDD",
      "motifDD",
      "signatureDD"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].nomeroEntreprise,
        dataList[i].nomUtilisateur,
        dataList[i].trajetDe,
        dataList[i].trajetA,
        dataList[i].mission,
        dataList[i].kilometrageSorite,
        dataList[i].kilometrageRetour,
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
