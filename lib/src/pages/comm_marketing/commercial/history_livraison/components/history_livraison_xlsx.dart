import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/comm_maketing/livraiason_history_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class HistoriqueLivraisonXlsx {
  Future<void> exportToExcel(List<LivraisonHistoryModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "HistoriqueLivraisons";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "idProduct",
      "quantity",
      "quantityAchat",
      "priceAchatUnit",
      "prixVenteUnit",
      "unite",
      "margeBen",
      "tva",
      "remise",
      "qtyRemise",
      "margeBenRemise",
      "qtyLivre",
      "succursale",
      "signature",
      "created",
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].idProduct,
        dataList[i].quantity,
        dataList[i].quantityAchat,
        dataList[i].priceAchatUnit,
        dataList[i].prixVenteUnit,
        dataList[i].unite,
        dataList[i].margeBen,
        dataList[i].tva,
        dataList[i].remise,
        dataList[i].qtyRemise,
        dataList[i].margeBenRemise,
        dataList[i].qtyLivre,
        dataList[i].succursale,
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
