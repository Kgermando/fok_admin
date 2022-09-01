import 'dart:io';
import 'dart:typed_data';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// Local import
import 'package:fokad_admin/src/helpers/save_file_mobile_pdf.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class SalairePdf {
  static Future<void> generate(PaiementSalaireModel data) async {
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
    return helper.saveAndLaunchFilePdf(bytes, 'salaire-$date.pdf');
  }

  static Widget buildHeader(PaiementSalaireModel data, UserModel user) =>
      Column(
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
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: data.matricule,
                ),
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

  static Widget buildCompagnyInfo(PaiementSalaireModel data, UserModel user) {
    final titles = <String>['RCCM:', 'N° Impôt:', 'ID Nat.:', 'Crée le:'];
    final datas = <String>[
      InfoSystem().rccm(),
      InfoSystem().nImpot(),
      InfoSystem().iDNat(),
      DateFormat("dd/MM/yy HH:mm").format(data.createdAt)
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

  static Widget buildTitle(PaiementSalaireModel data) {
    // final date = DateFormat("dd/MM/yy HH:mm").format(data.createdAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bulletin de paie '.toUpperCase(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static Widget buildBody(PaiementSalaireModel data) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      agentWidget(data),
      SizedBox(
        height: p20,
      ),
      salaireWidget(data),
      SizedBox(
        height: p20,
      ),
      heureSupplementaireWidget(data),
      SizedBox(
        height: p20,
      ),
      supplementTravailSamediDimancheJoursFerieWidget(data),
      SizedBox(
        height: p20,
      ),
      primeWidget(data),
      SizedBox(
        height: p20,
      ),
      diversWidget(data),
      SizedBox(
        height: p20,
      ),
      congesPayeWidget(data),
      SizedBox(
        height: p20,
      ),
      maladieAccidentWidget(data),
      SizedBox(
        height: p20,
      ),
      totalDuBrutWidget(data),
      SizedBox(
        height: p20,
      ),
      deductionWidget(data),
      SizedBox(
        height: p20,
      ),
      allocationsFamilialesWidget(data),
      SizedBox(
        height: p20,
      ),
      netAPayerWidget(data),
      SizedBox(
        height: p20,
      ),
      montantPrisConsiderationCalculCotisationsINSSWidget(data),
      SizedBox(
        height: p20,
      ),
    ]);
  }

  static Widget agentWidget(PaiementSalaireModel data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Matricule',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.matricule,
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Numéro de securité sociale',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.numeroSecuriteSociale,
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Nom',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.nom,
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Prénom',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.prenom,
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Téléphone',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.telephone,
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Adresse',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.adresse,
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Département',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.departement,
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Services d\'affectation',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.servicesAffectation,
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Salaire',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              "${NumberFormat.decimalPattern('fr').format(double.parse(data.salaire))} USD",
            ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Observation',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: (data.observation == 'true')
                    ? Text('Payé',
                        style: const pw.TextStyle(color: PdfColors.green))
                    : Text(
                        'Non payé',
                        style: const pw.TextStyle(color: PdfColors.red),
                      ))
          ],
        ),
        Divider(color: PdfColors.amber),
        Row(
          children: [
            Expanded(
              child: Text(
                'Mode de paiement',
                style: pw.TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: p10,
            ),
            Expanded(
                child: Text(
              data.modePaiement,
            ))
          ],
        ),
      ],
    );
  }

  static Widget salaireWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: PdfColors.amber),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Salaires',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text('Durée',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.tauxJourHeureMoisSalaire,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('%',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.joursHeuresPayeA100PourecentSalaire,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Total dû',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.totalDuSalaire,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget heureSupplementaireWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Heure supplementaire',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text('Nombre Heure',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.nombreHeureSupplementaires,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Taux',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.tauxHeureSupplementaires,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Total dû',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.totalDuHeureSupplementaires,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget supplementTravailSamediDimancheJoursFerieWidget(
      PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text(
                  'Supplement dû travail du samedi, du dimanche et jours ferié',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text('Supplement dû travail',
                      style: pw.TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  Text(
                    data.supplementTravailSamediDimancheJoursFerie,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  static Widget primeWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Prime',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text('Prime',
                      style: pw.TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  Text(
                    data.prime,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  static Widget diversWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Divers',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text('Divers',
                      style: pw.TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  Text(
                    data.divers,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  static Widget congesPayeWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Congés Payé',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text('Jours',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.joursCongesPaye,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Taux',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.tauxCongesPaye,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Total dû',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.totalDuHeureSupplementaires,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget maladieAccidentWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Maladie ou Accident',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text('Jours Payé',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.jourPayeMaladieAccident,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Taux',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.tauxJournalierMaladieAccident,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Total dû',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.totalDuMaladieAccident,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget totalDuBrutWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Total brut dû',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text('Total',
                      style: pw.TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  Text(
                    data.totalDuBrut,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  static Widget deductionWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Deduction',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Pension',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.pensionDeduction,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Indemnité compensatrices',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.indemniteCompensatricesDeduction,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Avances',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.avancesDeduction,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Divers',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.diversDeduction,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Retenues fiscales',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.retenuesFiscalesDeduction,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget allocationsFamilialesWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Allocations familiales',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Nombre des enfants béneficaire',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.nombreEnfantBeneficaireAllocationsFamiliales,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Nombre des Jours',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.nombreDeJoursAllocationsFamiliales,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Taux journalier',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.tauxJoursAllocationsFamiliales,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text('Total à payer',
                            style: pw.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(
                          data.totalAPayerAllocationsFamiliales,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget netAPayerWidget(PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text('Net à payer',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text('Total à payer',
                      style: pw.TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  Text(
                    data.netAPayer,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  static Widget montantPrisConsiderationCalculCotisationsINSSWidget(
      PaiementSalaireModel data) {
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: const BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: PdfColors.amber),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: Text(
                  'Montant pris en consideration pour le calcul des cotisations INSS',
                  style: pw.TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text('Montant pris pour la Cotisations INSS',
                      style: pw.TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)),
                  Text(
                    data.montantPrisConsiderationCalculCotisationsINSS,
                  ),
                ],
              )),
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
