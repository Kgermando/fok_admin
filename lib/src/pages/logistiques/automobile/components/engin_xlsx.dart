import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class EnginXlsx {
  Future<void> exportToExcel(List<AnguinModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Engins";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "nom",
      "modele",
      "marque",
      "numeroChassie",
      "couleur",
      "genre",
      "qtyMaxReservoir",
      "dateFabrication",
      "nomeroPLaque",
      "nomeroEntreprise",
      "kilometrageInitiale",
      "provenance",
      "typeCaburant",
      "typeMoteur",
      "signature",
      "created",
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
        dataList[i].nom,
        dataList[i].modele,
        dataList[i].marque,
        dataList[i].numeroChassie,
        dataList[i].couleur,
        dataList[i].genre,
        dataList[i].qtyMaxReservoir,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].dateFabrication),
        dataList[i].nomeroPLaque,
        dataList[i].nomeroEntreprise,
        dataList[i].kilometrageInitiale,
        dataList[i].provenance,
        dataList[i].typeCaburant,
        dataList[i].typeMoteur,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
        dataList[i].approbationDG,
        dataList[i].motifDG,
        dataList[i].signatureDG,
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
