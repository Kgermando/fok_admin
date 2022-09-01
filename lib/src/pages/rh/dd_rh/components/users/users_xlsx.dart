import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class UserXlsx {
  Future<void> exportToExcel(List<UserModel> dataList) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Agents actifs'];
    sheetObject.insertRowIterables([
      "id",
      "Nom",
      "Prenom",
      "Email",
      "Téléphone",
      "Matricule",
      "Département",
      "services d'Affectation",
      "fonction Occupeée",
      "Accreditation",
      "Status",
      "Date",
      "Succursale"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].nom,
        dataList[i].prenom,
        dataList[i].email,
        dataList[i].telephone.toString(),
        dataList[i].matricule,
        dataList[i].departement,
        dataList[i].servicesAffectation,
        dataList[i].fonctionOccupe,
        dataList[i].role.toString(),
        dataList[i].isOnline,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].createdAt),
        dataList[i].succursale,
      ];

      sheetObject.insertRowIterables(data, i + 1);
    }
    excel.setDefaultSheet('Agents actifs');
    final dir = await getApplicationDocumentsDirectory();
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);

    var onValue = excel.encode();
    File('${dir.path}/agents_actifs$date.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
  }
}
