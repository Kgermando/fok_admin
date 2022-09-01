import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CampagneXlsx {
  Future<void> exportToExcel(List<CampaignModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Campagnes";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "typeProduit",
      "dateDebutEtFin",
      "coutCampaign",
      "lieuCible",
      "promotion",
      "objectifs",
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
        dataList[i].typeProduit,
        dataList[i].dateDebutEtFin,
        dataList[i].coutCampaign,
        dataList[i].lieuCible,
        dataList[i].promotion,
        dataList[i].objectifs,
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
        dataList[i].ligneBudgetaire,
        dataList[i].ressource,
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
