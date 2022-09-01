import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class SalaireXlsx {
  Future<void> exportToExcel(
      List<PaiementSalaireModel> paiementSalaireList) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Salaire'];
    sheetObject.insertRowIterables([
      "id",
      "Nom",
      "PostNom",
      "Prénom",
      "Email",
      "Telephone",
      "Adresse",
      "Departement",
      "Numero de Securite Sociale",
      "Matricule",
      "Services d'Affectation",
      "Salaire",
      "Observation",
      "Mode de Paiement",
      "Date",
      "TauxJourHeureMoisSalaire",
      "joursHeuresPayeA100PourecentSalaire",
      "totalDuSalaire",
      "nombreHeureSupplementaires",
      "tauxHeureSupplementaires",
      "totalDuHeureSupplementaires",
      "supplementTravailSamediDimancheJoursFerie",
      "prime",
      "divers",
      "joursCongesPaye",
      "tauxCongesPaye",
      "totalDuCongePaye",
      "jourPayeMaladieAccident",
      "tauxJournalierMaladieAccident",
      "totalDuMaladieAccident",
      "pensionDeduction",
      "indemniteCompensatricesDeduction",
      "avancesDeduction",
      "diversDeduction",
      "retenuesFiscalesDeduction",
      "nombreEnfantBeneficaireAllocationsFamiliales",
      "nombreDeJoursAllocationsFamiliales",
      "tauxJoursAllocationsFamiliales",
      "totalAPayerAllocationsFamiliales",
      "netAPayer",
      "montantPrisConsiderationCalculCotisationsINSS",
      "totalDuBrut",
      "signature",
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

    for (int i = 0; i < paiementSalaireList.length; i++) {
      List<String> dataList = [
        paiementSalaireList[i].id.toString(),
        paiementSalaireList[i].nom,
        paiementSalaireList[i].postNom,
        paiementSalaireList[i].prenom,
        paiementSalaireList[i].email,
        paiementSalaireList[i].telephone,
        paiementSalaireList[i].adresse,
        paiementSalaireList[i].departement,
        paiementSalaireList[i].numeroSecuriteSociale,
        paiementSalaireList[i].matricule,
        paiementSalaireList[i].servicesAffectation,
        paiementSalaireList[i].salaire,
        paiementSalaireList[i].observation,
        paiementSalaireList[i].modePaiement,
        DateFormat("dd/MM/yy HH-mm").format(paiementSalaireList[i].createdAt),
        paiementSalaireList[i].tauxJourHeureMoisSalaire,
        paiementSalaireList[i].joursHeuresPayeA100PourecentSalaire,
        paiementSalaireList[i].totalDuSalaire,
        paiementSalaireList[i].nombreHeureSupplementaires,
        paiementSalaireList[i].tauxHeureSupplementaires,
        paiementSalaireList[i].totalDuHeureSupplementaires,
        paiementSalaireList[i].supplementTravailSamediDimancheJoursFerie,
        paiementSalaireList[i].prime,
        paiementSalaireList[i].divers,
        paiementSalaireList[i].joursCongesPaye,
        paiementSalaireList[i].tauxCongesPaye,
        paiementSalaireList[i].totalDuCongePaye,
        paiementSalaireList[i].jourPayeMaladieAccident,
        paiementSalaireList[i].tauxJournalierMaladieAccident,
        paiementSalaireList[i].totalDuMaladieAccident,
        paiementSalaireList[i].pensionDeduction,
        paiementSalaireList[i].indemniteCompensatricesDeduction,
        paiementSalaireList[i].avancesDeduction,
        paiementSalaireList[i].diversDeduction,
        paiementSalaireList[i].retenuesFiscalesDeduction,
        paiementSalaireList[i].nombreEnfantBeneficaireAllocationsFamiliales,
        paiementSalaireList[i].nombreDeJoursAllocationsFamiliales,
        paiementSalaireList[i].tauxJoursAllocationsFamiliales,
        paiementSalaireList[i].totalAPayerAllocationsFamiliales,
        paiementSalaireList[i].netAPayer,
        paiementSalaireList[i].montantPrisConsiderationCalculCotisationsINSS,
        paiementSalaireList[i].totalDuBrut,
        paiementSalaireList[i].signature,
        paiementSalaireList[i].approbationBudget,
        paiementSalaireList[i].motifBudget,
        paiementSalaireList[i].signatureBudget,
        paiementSalaireList[i].approbationFin,
        paiementSalaireList[i].motifFin,
        paiementSalaireList[i].signatureFin,
        paiementSalaireList[i].approbationDD,
        paiementSalaireList[i].motifDD,
        paiementSalaireList[i].signatureDD,
        paiementSalaireList[i].ligneBudgetaire,
        paiementSalaireList[i].ressource
      ];

      sheetObject.insertRowIterables(dataList, i + 1);
    }
    excel.setDefaultSheet('Salaire');
    final dir = await getApplicationDocumentsDirectory();
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);

    var onValue = excel.encode();
    File('${dir.path}/salaire$date.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
  }
}
