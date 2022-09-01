import 'dart:io';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/helpers/pdf_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/bon_livraison.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class BonLivraisonPDF {
  static Future<File> generate(
      BonLivraisonModel bonLivraisonModel, monnaie) async {
    final pdf = Document();

    final user = await AuthApi().getUserId();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(bonLivraisonModel, user),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(),
        buildInvoice(bonLivraisonModel, monnaie),

        // buildTotal(bonLivraisonModel, monnaie),
      ],
      footer: (context) => buildFooter(user),
    ));
    return PdfApi.saveDocument(name: 'bon_livraison', pdf: pdf);
  }

  static Widget buildHeader(
          BonLivraisonModel bonLivraisonModel, UserModel user) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(user),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: user.succursale,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(bonLivraisonModel, user),
              buildInvoiceInfo(bonLivraisonModel),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(
          BonLivraisonModel bonLivraisonModel, UserModel user) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Livré à ${bonLivraisonModel.succursale.toUpperCase()}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("adressee..."),
        ],
      );

  static Widget buildInvoiceInfo(BonLivraisonModel bonLivraisonModel) {
    final titles = <String>[
      'Date de livraison:',
      'Livré par:',
      'Contact:',
      'Accusée par'
    ];
    final data = <String>[
      DateFormat("dd/MM/yy HH:mm").format(bonLivraisonModel.created),
      '${bonLivraisonModel.firstName} ${bonLivraisonModel.lastName}',
      bonLivraisonModel.signature,
      (bonLivraisonModel.accuseReception == 'true')
          ? '${bonLivraisonModel.accuseReceptionFirstName} ${bonLivraisonModel.accuseReceptionLastName}'
          : '-',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(UserModel user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.succursale, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(InfoSystem().nameAdress()),
        ],
      );

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BON DE LIVRAISON',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // SizedBox(height: 0.8 * PdfPageFormat.cm),
          // Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(BonLivraisonModel bonLivraisonModel, monnaie) {
    // var prixAchatTotal = double.parse(bonLivraisonModel.priceAchatUnit) * double.parse(bonLivraisonModel.quantityAchat);

    // var margeBenifice = double.parse(bonLivraisonModel.prixVenteUnit) -
    //     double.parse(bonLivraisonModel.priceAchatUnit);

    // var margeBenificeTotal =
    //     margeBenifice * double.parse(bonLivraisonModel.quantityAchat);

    // var margeBenificeRemise = double.parse(bonLivraisonModel.remise) -
    //     double.parse(bonLivraisonModel.priceAchatUnit);

    // var margeBenificeTotalRemise = margeBenificeRemise *
    //     double.parse(bonLivraisonModel.quantityAchat);

    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          buildSimpleText1(
              title: 'Produit', value: bonLivraisonModel.idProduct),
          // SizedBox(height: 2 * PdfPageFormat.mm),
          Divider(),
          buildSimpleText1(
              title: 'Quantité Entrée',
              value:
                  '${NumberFormat.decimalPattern('fr').format(double.parse(bonLivraisonModel.quantityAchat))} ${bonLivraisonModel.unite}'),
          // SizedBox(height: 2 * PdfPageFormat.mm),
          // Divider(),
          // buildSimpleText1(title: 'Prix d\'achats unitaire', value: '${NumberFormat.decimalPattern('fr').format(double.parse(bonLivraisonModel.priceAchatUnit))} $monnaie',),
          // // SizedBox(height: 2 * PdfPageFormat.mm),
          // Divider(),
          // buildSimpleText1(title: 'Prix d\'achats total', value: '${NumberFormat.decimalPattern('fr').format(prixAchatTotal)} $monnaie'),
          // SizedBox(height: 2 * PdfPageFormat.mm),
          Divider(),
          buildSimpleText1(title: 'TVA', value: '${bonLivraisonModel.tva} %'),
          // SizedBox(height: 2 * PdfPageFormat.mm),
          Divider(),
          buildSimpleText1(
              title: 'Prix de vente unitaire',
              value:
                  '${NumberFormat.decimalPattern('fr').format(double.parse(bonLivraisonModel.prixVenteUnit))} $monnaie'),
          // SizedBox(height: 2 * PdfPageFormat.mm),

          if (double.parse(bonLivraisonModel.remise) >= 1) Divider(),
          if (double.parse(bonLivraisonModel.remise) >= 1)
            buildSimpleText1(
                title: 'Prix de Remise',
                value: '${bonLivraisonModel.remise} $monnaie'),
          // SizedBox(height: 2 * PdfPageFormat.mm),
          if (double.parse(bonLivraisonModel.qtyRemise) >= 1) Divider(),
          if (double.parse(bonLivraisonModel.qtyRemise) >= 1)
            buildSimpleText1(
                title: 'Qtés pour la remise',
                value:
                    '${bonLivraisonModel.qtyRemise} ${bonLivraisonModel.unite}'),
          // SizedBox(height: 2 * PdfPageFormat.mm),
          // Divider(),
          // buildSimpleText1(title: 'Marge bénéficiaire unitaire / Remise', value: '${NumberFormat.decimalPattern('fr').format(margeBenifice)} $monnaie / ${NumberFormat.decimalPattern('fr').format(margeBenificeRemise)} $monnaie'),
          // // SizedBox(height: 2 * PdfPageFormat.mm),
          // Divider(),
          // buildSimpleText1(title: 'Marge bénéficiaire total / Remise', value: '${NumberFormat.decimalPattern('fr').format(margeBenificeTotal)} $monnaie / ${NumberFormat.decimalPattern('fr').format(margeBenificeTotalRemise)} $monnaie'),
        ]);
  }

  static Widget buildFooter(UserModel user) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Entreprise', value: user.succursale),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'RCCM', value: "1234567821"),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'ID Nat.', value: "87975132152"),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'N° Impôt', value: "568972132"),
          SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

  static buildSimpleText1({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        // SizedBox(width: 4 * PdfPageFormat.mm),
        pw.Spacer(),
        Text(value),
      ],
    );
  }

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
