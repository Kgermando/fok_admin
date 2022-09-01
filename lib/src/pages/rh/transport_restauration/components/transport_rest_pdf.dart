// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// Local import
import 'package:fokad_admin/src/helpers/save_file_mobile_pdf.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class TransRestPdf {
  static Future<void> generate(List<TransRestAgentsModel> transRestAgentsList,
      TransportRestaurationModel data) async {
    final pdf = Document();
    final user = await AuthApi().getUserId();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(data, user),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(data),
        Divider(),
        buildBody(transRestAgentsList, data)
      ],
      footer: (context) => buildFooter(user),
    ));
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);
    final Uint8List bytes = await pdf.save();
    return helper.saveAndLaunchFilePdf(bytes, 'trans&rest-$date.pdf');
  }

  static Widget buildHeader(TransportRestaurationModel data, UserModel user) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildHeaderLogo(user),
            ],
          ),
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCompanyAddress(user),
              buildCompagnyInfo(data, user),
            ],
          ),
        ],
      );
  static Widget buildHeaderLogo(UserModel user) {
    final image = pw.MemoryImage(
      File(InfoSystem().logo()).readAsBytesSync(),
    );
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 80,
          height: 80,
          child: pw.Image(image),
        ),
        pw.Text(InfoSystem().namelong()),
        pw.Text("FOKAD SA",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
      ],
    );
  }

  static Widget buildCompanyAddress(UserModel user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 200,
            child: Text(InfoSystem().nameAdress(),
                style: const TextStyle(fontSize: 10)),
          )
        ],
      );

  static Widget buildCompagnyInfo(
      TransportRestaurationModel data, UserModel user) {
    final titles = <String>['RCCM:', 'N° Impôt:', 'ID Nat.:', 'Crée le:'];
    final datas = <String>[
      InfoSystem().rccm(),
      InfoSystem().nImpot(),
      InfoSystem().iDNat(),
      DateFormat("dd/MM/yy HH:mm").format(data.created)
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = datas[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildTitle(TransportRestaurationModel data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liste des Transports & Restaurations'.toUpperCase(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildBody(List<TransRestAgentsModel> transRestAgentsList,
      TransportRestaurationModel data) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('Intitlé :',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(data.title),
          )
        ],
      ),
      Divider(
        color: PdfColors.amber,
      ),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Observation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: p10,
          ),
          Expanded(
              flex: 3,
              child: (data.observation == 'true')
                  ? Text(
                      'Payé',
                      style: const TextStyle(color: PdfColors.greenAccent),
                    )
                  : Text(
                      'Non payé',
                      style: const TextStyle(color: PdfColors.redAccent),
                    ))
        ],
      ),
      Divider(
        color: PdfColors.amber,
      ),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('Signature:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(data.signature),
          )
        ],
      ),
      Divider(
        color: PdfColors.amber,
      ),
      tableListAgents(transRestAgentsList, data)
    ]);
  }

  static Widget tableListAgents(List<TransRestAgentsModel> transRestAgentsList,
      TransportRestaurationModel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
        },
        children: [
          tableRowHeader(),
          for (var item in transRestAgentsList) tableRow(item, data)
        ],
      ),
    );
  }

  static TableRow tableRowHeader() {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: Text("Nom"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: Text("Prenom"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: Text("Matricule"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: Text("Montant"),
      ),
    ]);
  }

  static TableRow tableRow(
      TransRestAgentsModel item, TransportRestaurationModel data) {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: Text(item.nom),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: Text(item.prenom),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: Text(item.matricule),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: Text(
            "${NumberFormat.decimalPattern('fr').format(double.parse(item.montant))} \$"),
      ),
    ]);
  }

  static Widget buildFooter(UserModel user) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Address', value: invoice.supplier.address),
          // SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
          pw.Text('Fonds Kasaiens de développement.',
              style: const pw.TextStyle(fontSize: 10))
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
