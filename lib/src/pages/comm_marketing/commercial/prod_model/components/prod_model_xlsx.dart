import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ProdModelXlsx {
  Future<void> exportToExcel(List<ProductModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Modèle Produits";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "categorie",
      "sousCategorie1",
      "sousCategorie2",
      "sousCategorie3",
      "sousCategorie4",
      "idProduct",
      "signature",
      "created",
      "approbationDD",
      "motifDD",
      "signatureDD"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].categorie,
        dataList[i].sousCategorie1,
        dataList[i].sousCategorie2,
        dataList[i].sousCategorie3,
        dataList[i].sousCategorie4,
        dataList[i].idProduct,
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
