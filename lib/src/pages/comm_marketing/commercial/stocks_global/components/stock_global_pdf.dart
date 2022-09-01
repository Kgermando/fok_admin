import 'dart:io';
import 'dart:typed_data';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// Local import
import 'package:fokad_admin/src/helpers/save_file_mobile_pdf.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class StockGlobalPdf {
  static Future<void> generate(StocksGlobalMOdel data) async {
    final pdf = Document();
    final user = await AuthApi().getUserId();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(data, user),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(data),
        Divider(),
        buildBody(data)
      ],
      footer: (context) => buildFooter(user),
    ));
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);
    final Uint8List bytes = await pdf.save();
    return helper.saveAndLaunchFilePdf(bytes, 'stock-global-$date.pdf');
  }

  static Widget buildHeader(StocksGlobalMOdel data, UserModel user) => Column(
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

  static Widget buildCompagnyInfo(StocksGlobalMOdel data, UserModel user) {
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

  static Widget buildTitle(StocksGlobalMOdel data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.idProduct.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildBody(StocksGlobalMOdel data) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      achats(data),
      SizedBox(
        height: 20,
      ),
      disponiblesTitle(),
      disponibles(data),
      SizedBox(
        height: 30,
      ),
      // achatHistorityTitle(),
      // SizedBox(
      //   height: 20,
      // ),
    ]);
  }

  static Widget achats(StocksGlobalMOdel stocksGlobalMOdel) {
    var prixAchatTotal = double.parse(stocksGlobalMOdel.priceAchatUnit) *
        double.parse(stocksGlobalMOdel.quantityAchat);

    var margeBenifice = double.parse(stocksGlobalMOdel.prixVenteUnit) -
        double.parse(stocksGlobalMOdel.priceAchatUnit);
    var margeBenificeTotal =
        margeBenifice * double.parse(stocksGlobalMOdel.quantityAchat);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Quantités entrant',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(stocksGlobalMOdel.quantityAchat).toStringAsFixed(0)))} ${stocksGlobalMOdel.unite}',
              ),
            ],
          ),
          Divider(color: PdfColors.amber),
          Row(
            children: [
              Text('Prix d\'achats unitaire',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(stocksGlobalMOdel.priceAchatUnit).toStringAsFixed(2)))} \$',
              ),
            ],
          ),
          Divider(color: PdfColors.amber),
          Row(
            children: [
              Text('Prix d\'achats total',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(prixAchatTotal.toStringAsFixed(2)))} \$',
              ),
            ],
          ),
          if (double.parse(stocksGlobalMOdel.tva) > 1)
            Divider(color: PdfColors.amber),
          if (double.parse(stocksGlobalMOdel.tva) > 1)
            Row(
              children: [
                Text('TVA', style: TextStyle(fontWeight: pw.FontWeight.bold)),
                Spacer(),
                Text('${stocksGlobalMOdel.tva} %'),
              ],
            ),
          Divider(color: PdfColors.amber),
          Row(
            children: [
              Text('Prix de vente unitaire',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(stocksGlobalMOdel.prixVenteUnit).toStringAsFixed(2)))} \$',
              ),
            ],
          ),
          Divider(color: PdfColors.amber),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Text('Marge bénéficiaire unitaire',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$',
              ),
            ],
          ),
          Divider(
            color: PdfColors.amber,
          ),
          Row(
            children: [
              Text('Marge bénéficiaire total',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$',
              ),
            ],
          )
        ],
      ),
    );
  }

  static Widget disponiblesTitle() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'DISPONIBLES',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }

  static Widget disponibles(StocksGlobalMOdel stocksGlobalMOdel) {
    var prixTotalRestante = double.parse(stocksGlobalMOdel.quantity) *
        double.parse(stocksGlobalMOdel.prixVenteUnit);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restes des ${stocksGlobalMOdel.unite}',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Text('Revenus', style: TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(stocksGlobalMOdel.quantity).toStringAsFixed(0)))} ${stocksGlobalMOdel.unite}',
              ),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalRestante.toStringAsFixed(2)))} \$',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // static Widget achatHistorityTitle() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: Text(
  //       'FICHES DE STOCKS',
  //       textAlign: TextAlign.center,
  //       style: TextStyle(fontWeight: pw.FontWeight.bold),
  //     ),
  //   );
  // }

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
