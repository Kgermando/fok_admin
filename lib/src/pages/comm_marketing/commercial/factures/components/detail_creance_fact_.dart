import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/creance_facture_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/helpers/pdf_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/components/table_creance_cart.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/pdf/creance_cart_pdf.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailCreanceFact extends StatefulWidget {
  const DetailCreanceFact({Key? key}) : super(key: key);

  @override
  State<DetailCreanceFact> createState() => _DetailCreanceFactState();
}

class _DetailCreanceFactState extends State<DetailCreanceFact> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<dynamic> factureList = [];

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                    padding: const EdgeInsets.all(p10),
                    child: FutureBuilder<CreanceCartModel>(
                        future: CreanceFactureApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<CreanceCartModel> snapshot) {
                          if (snapshot.hasData) {
                            CreanceCartModel? data = snapshot.data;
                            factureList = jsonDecode(data!.cart) as List;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (!Responsive.isMobile(context))
                                      SizedBox(
                                        width: p20,
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(Icons.arrow_back)),
                                      ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: Responsive.isDesktop(context)
                                              ? 'Commercial & Marketing'
                                              : 'Comm. & Mark.',
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                  children: [
                                    pageDetail(data),
                                    const SizedBox(height: p20),
                                    totalCart(data)
                                  ],
                                )))
                              ],
                            );
                          } else {
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(CreanceCartModel data) {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: 'Facture n° ${data.client}'),
                  Column(
                    children: [
                      Row(
                        children: [
                          PrintWidget(
                              tooltip: 'Imprimer le document',
                              onPressed: () async {
                                final pdfFile =
                                    await CreanceCartPDF.generate(data, "\$");
                                PdfApi.openFile(pdfFile);
                              })
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              Divider(
                color: mainColor,
              ),
              dataWidget(data),
              Divider(
                color: mainColor,
              ),
              TableCreanceCart(factureList: factureList)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(CreanceCartModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget totalCart(CreanceCartModel data) {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }

    List<dynamic> cartItem;
    // cartItem = facture!.cart.toList();
    cartItem = jsonDecode(data.cart) as List;

    List<CartModel> cartItemList = [];

    for (var element in cartItem) {
      cartItemList.add(CartModel.fromJson(element));
    }

    double sumCart = 0;
    for (var data in cartItemList) {
      var qtyRemise = double.parse(data.qtyRemise);
      var quantity = double.parse(data.quantityCart);
      if (quantity >= qtyRemise) {
        sumCart += double.parse(data.remise) * double.parse(data.quantityCart);
      } else {
        sumCart +=
            double.parse(data.priceCart) * double.parse(data.quantityCart);
      }
    }
    return Card(
      elevation: 5,
      color: mainColor.withOpacity(.5),
      child: Container(
        width: width,
        margin: const EdgeInsets.all(p20),
        child: Text(
          'Total: ${NumberFormat.decimalPattern('fr').format(sumCart)} \$',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
