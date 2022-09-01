import 'dart:io';
import 'dart:typed_data';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_bilan_ref_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// Local import
import 'package:fokad_admin/src/helpers/save_file_mobile_pdf.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class BilanPdf {
  static Future<void> generate(
      BilanModel data,
      List<CompteBilanRefModel> compteActifList,
      List<CompteBilanRefModel> comptePassifList) async {
    final pdf = Document();
    final user = await AuthApi().getUserId();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(data, user),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(data),
        Divider(),
        buildBody(data, compteActifList, comptePassifList),
        totalMontant(data, compteActifList, comptePassifList)
      ],
      footer: (context) => buildFooter(user),
    ));
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);
    final Uint8List bytes = await pdf.save();
    return helper.saveAndLaunchFilePdf(bytes, 'journal-$date.pdf');
  }

  static Widget buildHeader(BilanModel data, UserModel user) => Column(
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

  static Widget buildCompagnyInfo(BilanModel data, UserModel user) {
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

  static Widget buildTitle(BilanModel data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.titleBilan.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildBody(
      BilanModel data,
      List<CompteBilanRefModel> compteActifList,
      List<CompteBilanRefModel> comptePassifList) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('ACTIF',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: p20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text("Comptes",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Montant",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                SizedBox(height: p30),
                SizedBox(
                    // height: MediaQuery.of(context).size.height / 1.5,
                    child: compteActifWidget(compteActifList))
              ],
            ),
          ),
          Container(
            color: PdfColors.amber,
            width: 2,
            // height: MediaQuery.of(context).size.height / 1.5
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(p8),
              child: Column(
                children: [
                  Text('PASSIF',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: p20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text("Comptes",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Montant",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  SizedBox(height: p30),
                  SizedBox(
                      // height: MediaQuery.of(context).size.height / 1.5,
                      child: comptePassifWidget(comptePassifList))
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  static Widget compteActifWidget(List<CompteBilanRefModel> compteActifList) {
    return ListView.builder(
      itemCount: compteActifList.length,
      itemBuilder: (context, index) {
        final actif = compteActifList[index];
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(actif.comptes, textAlign: TextAlign.left),
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
                        "${NumberFormat.decimalPattern('fr').format(double.parse(actif.montant))} \$",
                        textAlign: TextAlign.center),
                  ),
                )
              ],
            ),
            Divider(color: PdfColors.amber),
          ],
        );
      },
    );
  }

  static Widget comptePassifWidget(List<CompteBilanRefModel> comptePassifList) {
    return ListView.builder(
      itemCount: comptePassifList.length,
      itemBuilder: (context, index) {
        final passif = comptePassifList[index];
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(passif.comptes, textAlign: TextAlign.left),
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
                        "${NumberFormat.decimalPattern('fr').format(double.parse(passif.montant))} \$",
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

  static Widget totalMontant(
      BilanModel data,
      List<CompteBilanRefModel> compteActifList,
      List<CompteBilanRefModel> comptePassifList) {
    double totalActif = 0.0;
    var actifList = compteActifList
        .where((element) => element.reference == data.id)
        .toList();
    for (var item in actifList) {
      totalActif += double.parse(item.montant);
    }

    double totalPassif = 0.0;
    var passifList = comptePassifList
        .where((element) => element.reference == data.id)
        .toList();
    for (var item in passifList) {
      totalPassif += double.parse(item.montant);
    }
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('TOTAL :',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                      "${NumberFormat.decimalPattern('fr').format(totalActif)} \$",
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: PdfColors.red)),
                )
              ],
            ),
          ),
          SizedBox(width: p20),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('TOTAL :',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                      "${NumberFormat.decimalPattern('fr').format(totalPassif)} \$",
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: PdfColors.red)),
                )
              ],
            ),
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
