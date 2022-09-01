import 'dart:io';
import 'dart:typed_data';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/comptabilites/balance_comptes_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// Local import
import 'package:fokad_admin/src/helpers/save_file_mobile_pdf.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class BalancePdf {
  static Future<void> generate(BalanceCompteModel data,
      List<CompteBalanceRefModel> compteBalanceRefList) async {
    final pdf = Document();
    final user = await AuthApi().getUserId();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(data, user),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(data),
        Divider(),
        buildBody(data, compteBalanceRefList),
        totalMontant(data, compteBalanceRefList)
      ],
      footer: (context) => buildFooter(user),
    ));
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);
    final Uint8List bytes = await pdf.save();
    return helper.saveAndLaunchFilePdf(bytes, 'compte-balance-$date.pdf');
  }

  static Widget buildHeader(BalanceCompteModel data, UserModel user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildHeaderLogo(user),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(barcode: Barcode.qrCode(), data: "FOKAD"),
              ),
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

  static Widget buildCompagnyInfo(BalanceCompteModel data, UserModel user) {
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

  static Widget buildTitle(BalanceCompteModel data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildBody(BalanceCompteModel data,
      List<CompteBalanceRefModel> compteBalanceRefList) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: p20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Text("Comptes",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          left: BorderSide(
                            color: PdfColors.amber,
                            width: 2,
                          ),
                        )),
                        child: Text("Débit",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          left: BorderSide(
                            color: PdfColors.amber,
                            width: 2,
                          ),
                        )),
                        child: Text("Crédit",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          left: BorderSide(
                            color: PdfColors.amber,
                            width: 2,
                          ),
                        )),
                        child: Text("Solde débit/crédit",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
                Divider(color: PdfColors.amber),
                SizedBox(height: p30),
                compteWidget(compteBalanceRefList)
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  static Widget compteWidget(List<CompteBalanceRefModel> compteBalanceRefList) {
    return ListView.builder(
      itemCount: compteBalanceRefList.length,
      itemBuilder: (context, index) {
        final compte = compteBalanceRefList[index];
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(compte.comptes, textAlign: TextAlign.left),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(
                        color: PdfColors.amber,
                        width: 2,
                      ),
                    )),
                    child: Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(compte.debit))} \$",
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(
                        color: PdfColors.amber,
                        width: 2,
                      ),
                    )),
                    child: Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(compte.credit))} \$",
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(
                        color: PdfColors.amber,
                        width: 2,
                      ),
                    )),
                    child: Text(
                        "${NumberFormat.decimalPattern('fr').format(compte.solde)} \$",
                        textAlign: TextAlign.center),
                  ),
                )
              ],
            ),
            Divider(
              color: PdfColors.amber,
            ),
          ],
        );
      },
    );
  }

  static Widget totalMontant(BalanceCompteModel data,
      List<CompteBalanceRefModel> compteBalanceRefList) {
    double totalDebit = 0.0;
    double totalCredit = 0.0;
    double totalSolde = 0.0;

    for (var item in compteBalanceRefList) {
      totalDebit += double.parse(item.debit);
      totalCredit += double.parse(item.credit);
      totalSolde += double.parse(item.solde);
    }

    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text("TOTAL :",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: PdfColors.amber,
                      width: 2,
                    ),
                  )),
                  child: Text(
                      "${NumberFormat.decimalPattern('fr').format(totalDebit)} \$",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: PdfColors.amber,
                      width: 2,
                    ),
                  )),
                  child: Text(
                      "${NumberFormat.decimalPattern('fr').format(totalCredit)} \$",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: PdfColors.amber,
                      width: 2,
                    ),
                  )),
                  child: Text(
                      "${NumberFormat.decimalPattern('fr').format(totalSolde)} \$",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ],
      ),
    );
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
