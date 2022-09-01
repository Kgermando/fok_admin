import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AgentXlsx {
  Future<void> exportToExcel(List<AgentModel> dataList) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Agents'];
    sheetObject.insertRowIterables([
      "id",
      "nom",
      "postNom",
      "prenom",
      "email",
      "telephone",
      "adresse",
      "sexe",
      "role",
      "matricule",
      "numeroSecuriteSociale",
      "dateNaissance",
      "lieuNaissance",
      "nationalite",
      "typeContrat",
      "departement",
      "servicesAffectation",
      "dateDebutContrat",
      "dateFinContrat",
      "fonctionOccupe",
      "competance",
      "experience",
      "statutAgent",
      "createdAt",
      "photo",
      "salaire",
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
        dataList[i].postNom,
        dataList[i].prenom,
        dataList[i].email,
        dataList[i].telephone,
        dataList[i].adresse,
        dataList[i].sexe,
        dataList[i].role,
        dataList[i].matricule,
        dataList[i].numeroSecuriteSociale,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].dateNaissance),
        dataList[i].lieuNaissance,
        dataList[i].nationalite,
        dataList[i].typeContrat,
        dataList[i].departement,
        dataList[i].servicesAffectation,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].dateDebutContrat),
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].dateFinContrat),
        dataList[i].fonctionOccupe,
        dataList[i].competance!,
        dataList[i].experience!,
        dataList[i].statutAgent,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].createdAt),
        dataList[i].photo!,
        dataList[i].salaire,
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
    excel.setDefaultSheet('Agents');
    final dir = await getApplicationDocumentsDirectory();
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);

    var onValue = excel.encode();
    File('${dir.path}/agent$date.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
  }
}
