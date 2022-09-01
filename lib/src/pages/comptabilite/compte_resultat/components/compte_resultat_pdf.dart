import 'dart:io';
import 'dart:typed_data';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_resultat_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// Local import
import 'package:fokad_admin/src/helpers/save_file_mobile_pdf.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class CompteResultatPdf {
  static Future<void> generate(
      CompteResulatsModel data,
      double totalCharges1,
      double totalCharges123,
      double totalGeneralCharges,
      double totalProduits1,
      double totalProduits123,
      double totalGeneralProduits) async {
    final pdf = Document();
    final user = await AuthApi().getUserId();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(data, user),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(data),
        Divider(),
        buildBody(data, totalCharges1, totalCharges123, totalGeneralCharges,
            totalProduits1, totalProduits123, totalGeneralProduits)
      ],
      footer: (context) => buildFooter(user),
    ));
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);
    final Uint8List bytes = await pdf.save();
    return helper.saveAndLaunchFilePdf(bytes, 'journal-$date.pdf');
  }

  static Widget buildHeader(CompteResulatsModel data, UserModel user) => Column(
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

  static Widget buildCompagnyInfo(CompteResulatsModel data, UserModel user) {
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

  static Widget buildTitle(CompteResulatsModel data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.intitule.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildBody(
      CompteResulatsModel data,
      double totalCharges1,
      double totalCharges123,
      double totalGeneralCharges,
      double totalProduits1,
      double totalProduits123,
      double totalGeneralProduits) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Charges (Hors taxes)',
                    textAlign: TextAlign.left,
                    style: pw.TextStyle(fontWeight: FontWeight.bold)),
                Divider(color: PdfColors.amber),
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
                      child: Text("Exercice",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                Divider(color: PdfColors.amber),
                SizedBox(height: p30),
                chargeWidget(
                    data, totalCharges1, totalCharges123, totalGeneralCharges)
              ],
            ),
          ),
          Container(
            color: PdfColors.amber,
            width: 2,
            // height: MediaQuery.of(context).size.height / 1.3
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: p8),
              child: Column(
                children: [
                  Text('Produits (Hors taxes)',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider(color: PdfColors.amber),
                  SizedBox(height: p20),
                  Row(
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
                        child: Text("Exercice",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  Divider(color: PdfColors.amber),
                  SizedBox(height: p30),
                  produitWidget(data, totalProduits1, totalProduits123,
                      totalGeneralProduits)
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  static Widget chargeWidget(CompteResulatsModel data, double totalCharges1,
      double totalCharges123, double totalGeneralCharges) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Achats Marchandises", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.achatMarchandises))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Variation Stock Marchandises",
                  textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.variationStockMarchandises))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Achats Approvionnements", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.achatApprovionnements))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child:
                  Text("Variation Approvionnements", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.variationApprovionnements))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Autres Charges Externe", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.autresChargesExterne))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Impôts Taxes et Versements Assimilés",
                  textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.impotsTaxesVersementsAssimiles))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child:
                  Text("Renumeration du Personnel", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.renumerationPersonnel))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Charges Sociales", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.chargesSocialas))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Dotatiopns Provisions", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.dotatiopnsProvisions))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Autres Charges", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.autresCharges))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Charges financieres", textAlign: TextAlign.left),
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
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.chargesfinancieres))} \$",
                    textAlign: TextAlign.center),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text('Total (I):',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 1,
              child: Text(
                  "${NumberFormat.decimalPattern('fr').format(totalCharges1)} \$",
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: PdfColors.red)),
            )
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child:
                  Text("Charges exptionnelles (II)", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.chargesExptionnelles))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Impôt Sur les benefices (III)",
                  textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.impotSurbenefices))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Total des charges(I + II + III):',
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                        "${NumberFormat.decimalPattern('fr').format(totalCharges123)} \$",
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: PdfColors.red)),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Solde Crediteur (bénéfice) ",
                  textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.soldeCrediteur))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: p20),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('TOTAL GENERAL :',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                        "${NumberFormat.decimalPattern('fr').format(totalGeneralCharges)} \$",
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: PdfColors.red)),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
      ],
    );
  }

  static Widget produitWidget(CompteResulatsModel data, double totalProduits1,
      double totalProduits123, double totalGeneralProduits) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Ventes Marchandises", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.ventesMarchandises))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Production Vendue des Biens Et Services",
                  textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.productionVendueBienEtSerices))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Production Stockée", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.productionStockee))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Production Immobilisée", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.productionImmobilisee))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child:
                  Text("Subvention d'exploitations", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.subventionExploitation))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Autres Produits", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.autreProduits))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("Produit financieres", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.produitfinancieres))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.amber,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total (I):',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Dont à l'exportation :", textAlign: TextAlign.left),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                      "${NumberFormat.decimalPattern('fr').format(totalProduits1)} \$",
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: PdfColors.red)),
                  Text(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.montantExportation))} \$",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child:
                  Text("Produit exceptionnels (II)", textAlign: TextAlign.left),
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
                  "${NumberFormat.decimalPattern('fr').format(double.parse(data.produitExceptionnels))} \$",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Total des produits(I + II):',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                        "${NumberFormat.decimalPattern('fr').format(totalProduits123)} \$",
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: PdfColors.red)),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child:
                  Text("Solde debiteur (pertes) :", textAlign: TextAlign.left),
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
                    "${NumberFormat.decimalPattern('fr').format(double.parse(data.soldeDebiteur))} \$",
                    textAlign: TextAlign.center),
              ),
            )
          ],
        ),
        SizedBox(height: p20),
        Divider(
          color: PdfColors.red,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('TOTAL GENERAL :',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                        "${NumberFormat.decimalPattern('fr').format(totalGeneralProduits)} \$",
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: PdfColors.red)),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: PdfColors.red,
        ),
      ],
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
