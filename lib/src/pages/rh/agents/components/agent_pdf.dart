// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// Local import
import 'package:fokad_admin/src/helpers/save_file_mobile_pdf.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class AgentPdf {
  static Future<void> generate(AgentModel data) async {
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
    return helper.saveAndLaunchFilePdf(bytes, 'rh-$date.pdf');
  }

  static Widget buildHeader(AgentModel data, UserModel user) => Column(
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

  static Widget buildCompagnyInfo(AgentModel data, UserModel user) {
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

  static Widget buildTitle(AgentModel data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Curriculum vitæ'.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildBody(AgentModel data) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Expanded(
            child: Text('Nom :'),
          ),
          Expanded(
            child: Text(data.nom),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Post-Nom :'),
          ),
          Expanded(
            child: Text(
              data.postNom,
              // textAlign: TextAlign.start, style: bodyMedium
            ),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text(
              'Prénom :',
              // textAlign: TextAlign.start,
              // style: bodyMedium.copyWith(fontWeight: FontWeight.bold)
            ),
          ),
          Expanded(
            child: Text(data.prenom),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Email :'),
          ),
          Expanded(
            child: Text(data.email),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Téléphone :'),
          ),
          Expanded(
            child: Text(data.telephone),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Sexe :'),
          ),
          Expanded(
            child: Text(data.sexe),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Niveau d\'accréditation :'),
          ),
          Expanded(
            child: Text(data.role),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Matricule :'),
          ),
          Expanded(
            child: Text(data.matricule),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Numéro de sécurité sociale :'),
          ),
          Expanded(
            child: Text(
              data.numeroSecuriteSociale,
            ),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Lieu de naissance :'),
          ),
          Expanded(
            child: Text(data.lieuNaissance),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text(
              'Date de naissance :',
            ),
          ),
          Expanded(
            child: Text(
              DateFormat("dd-MM-yyyy").format(data.dateNaissance),
            ),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text('Nationalité :'),
          ),
          Expanded(
            child: Text(data.nationalite),
          )
        ],
      ),
      SizedBox(height: p10),
      Row(
        children: [
          Expanded(
            child: Text(
              'Adresse :',
            ),
          ),
          Expanded(
            child: Text(data.adresse),
          )
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Formation :',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: p10),
              Text(data.competance!, textAlign: pw.TextAlign.justify)
            ],
          ),
          SizedBox(height: p30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Experience :',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: p10),
              Text(data.experience!, textAlign: pw.TextAlign.justify)
            ],
          ),
        ],
      )
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
