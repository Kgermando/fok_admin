import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_resultat_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CompteResulatXlsx {
  Future<void> exportToExcel(List<CompteResulatsModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "CompteResulats";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "intitule",
      "achatMarchandises",
      "variationStockMarchandises",
      "achatApprovionnements",
      "variationApprovionnements",
      "autresChargesExterne",
      "impotsTaxesVersementsAssimiles",
      "renumerationPersonnel",
      "chargesSocialas",
      "dotatiopnsProvisions",
      "autresCharges",
      "chargesfinancieres",
      "chargesExptionnelles",
      "impotSurbenefices",
      "soldeCrediteur",
      "ventesMarchandises",
      "productionVendueBienEtSerices",
      "productionStockee",
      "productionImmobilisee",
      "subventionExploitation",
      "autreProduits",
      "montantExportation",
      "produitfinancieres",
      "produitExceptionnels",
      "soldeDebiteur",
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
        dataList[i].intitule,
        dataList[i].achatMarchandises,
        dataList[i].variationStockMarchandises,
        dataList[i].achatApprovionnements,
        dataList[i].variationApprovionnements,
        dataList[i].autresChargesExterne,
        dataList[i].impotsTaxesVersementsAssimiles,
        dataList[i].renumerationPersonnel,
        dataList[i].chargesSocialas,
        dataList[i].dotatiopnsProvisions,
        dataList[i].autresCharges,
        dataList[i].chargesfinancieres,
        dataList[i].chargesExptionnelles,
        dataList[i].impotSurbenefices,
        dataList[i].soldeCrediteur,
        dataList[i].ventesMarchandises,
        dataList[i].productionVendueBienEtSerices,
        dataList[i].productionStockee,
        dataList[i].productionImmobilisee,
        dataList[i].subventionExploitation,
        dataList[i].autreProduits,
        dataList[i].montantExportation,
        dataList[i].produitfinancieres,
        dataList[i].produitExceptionnels,
        dataList[i].soldeDebiteur,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
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
