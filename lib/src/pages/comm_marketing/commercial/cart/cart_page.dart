import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/cart_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/creance_facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/gain_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/number_facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_cart_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/helpers/pdf_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/facture_cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/gain_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/number_facture.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/cart/components/cart_item_widget.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/pdf/creance_cart_pdf.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/pdf/facture_cart_pdf.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isloading = false;

  // For cloud to send local
  List<CartModel> listDataCart = [];
  List<CartModel> panierBtnList = [];
  int numberFacture = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

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
    List<CartModel>? dataList = await CartApi().getAllData(userModel.matricule);
    final numberFac = await NumberFactureApi().getAllData();
    if (!mounted) return;
    setState(() {
      user = userModel;
      listDataCart = dataList;
      panierBtnList =
          dataList; // Pour verrouiller le button d'achat si le panier est vide
      numberFacture = numberFac.length + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton:
            (panierBtnList.isNotEmpty) ? speedialWidget() : Container(),
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
                    child: FutureBuilder<List<CartModel>>(
                        future: CartApi().getAllData(user.matricule),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<CartModel>> snapshot) {
                          if (snapshot.hasData) {
                            List<CartModel>? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
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
                                    child: data!.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Le panier est vide.',
                                              style:
                                                  Responsive.isDesktop(context)
                                                      ? const TextStyle(
                                                          fontSize: 24)
                                                      : const TextStyle(
                                                          fontSize: 16),
                                            ),
                                          )
                                        : Scrollbar(
                                            controller: _controllerScroll,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                      controller:
                                                          _controllerScroll,
                                                      itemCount: data.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final cart =
                                                            data[index];
                                                        return CartItemWidget(
                                                            cart: cart);
                                                      }),
                                                ),
                                                isloading
                                                    ? loading()
                                                    : totalCart(),
                                              ],
                                            ),
                                          ))
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

  Widget totalCart() {
    // Montant a Vendre
    double sumCart = 0.0;

    var dataPriceCart = listDataCart
        .map((e) => (double.parse(e.quantityCart) >= double.parse(e.qtyRemise))
            ? double.parse(e.remise) * double.parse(e.quantityCart)
            : double.parse(e.priceCart) * double.parse(e.quantityCart))
        .toList();

    for (var data in dataPriceCart) {
      sumCart += data;
    }

    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        'Total: ${NumberFormat.decimalPattern('fr').format(sumCart)} \$',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700),
      ),
    );
  }

  SpeedDial speedialWidget() {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
            child: const Icon(Icons.inventory_rounded),
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal.shade700,
            label: 'Vente',
            onPressed: factureData),
        SpeedDialChild(
            child: const Icon(Icons.print),
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal.shade700,
            label: 'Générer facture',
            onPressed: () {
              if (isloading) return;
              factureData();
              _createFacturePDF();
            }),
        SpeedDialChild(
            child: const Icon(Icons.money_off),
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange.shade700,
            label: 'Vente à crédit',
            onPressed: () {
              if (isloading) return;
              creanceData();
            }),
        SpeedDialChild(
            child: const Icon(Icons.print),
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange.shade700,
            label: 'Générer facture créance',
            onPressed: () {
              if (isloading) return;
              creanceData();
              _createPDFCreance();
            }),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  Future<void> factureData() async {
    // final jsonList = listDataCart.map((item) => jsonEncode(item)).toList();
    final jsonList = jsonEncode(listDataCart);
    final factureCartModel = FactureCartModel(
        cart: jsonList,
        client: '$numberFacture',
        succursale: user.succursale.toString(),
        signature: user.matricule.toString(),
        created: DateTime.now());
    await FactureApi().insertData(factureCartModel);

    // Genere le numero de la facture
    numberFactureField(numberFacture.toString(), user.succursale.toString(),
        user.matricule.toString());
    // Ajout des items dans historique
    venteHisotory();
    // Add Gain par produit
    gainVentes();
    // Suppressions total de la table cart
    cleanCart().then((value) {
      Navigator.pushNamed(context, ComMarketingRoutes.comMarketingVente);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Facture $numberFacture ajouté."),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  // PDF Generate Facture
  Future<void> _createFacturePDF() async {
    // final jsonList = listDataCart.map((item) => jsonEncode(item)).toList();
    final jsonList = jsonEncode(listDataCart);
    final factureCartModel = FactureCartModel(
        cart: jsonList,
        client: '$numberFacture',
        succursale: user.succursale.toString(),
        signature: user.matricule.toString(),
        created: DateTime.now());

    List<FactureCartModel> factureList = [];
    factureList.add(factureCartModel);

    // ignore: unused_local_variable
    FactureCartModel? facture;

    for (var item in factureList) {
      facture = item;
    }
    final pdfFile = await FactureCartPDF.generate(facture!, '\$');
    PdfApi.openFile(pdfFile);
  }

  Future<void> creanceData() async {
    final jsonList = jsonEncode(listDataCart);
    final creanceCartModel = CreanceCartModel(
        cart: jsonList,
        client: '$numberFacture',
        succursale: user.succursale.toString(),
        signature: user.matricule.toString(),
        created: DateTime.now());
    await CreanceFactureApi().insertData(creanceCartModel);
    // Genere le numero de la facture
    numberFactureField(numberFacture.toString(), user.succursale.toString(),
        user.matricule.toString());
    // Ajout des items dans historique
    venteHisotory();
    // Add Gain par par produit
    gainVentes();
    // suppressions total de la table cart
    cleanCart().then((value) {
      Navigator.pushNamed(context, ComMarketingRoutes.comMarketingVente);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Créance $numberFacture ajouté."),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  // PDF Generate Creance
  Future<void> _createPDFCreance() async {
    final jsonList = jsonEncode(listDataCart);
    final creanceCartModel = CreanceCartModel(
        cart: jsonList,
        client: '$numberFacture',
        succursale: user.succursale.toString(),
        signature: user.matricule.toString(),
        created: DateTime.now());

    List<CreanceCartModel> creanceList = [];
    creanceList.add(creanceCartModel);

    // ignore: unused_local_variable
    CreanceCartModel? creance;

    for (var item in creanceList) {
      creance = item;
    }

    final pdfFile = await CreanceCartPDF.generate(creance!, '\$');
    PdfApi.openFile(pdfFile);

    // PdfApi.openFile(pdfFile);
  }

  Future<void> cleanCart() async {
    await CartApi().deleteAllData(user.matricule);
  }

  Future<void> numberFactureField(
      String number, String succursale, String signature) async {
    final numberFactureModel = NumberFactureModel(
        number: number,
        succursale: succursale,
        signature: signature,
        created: DateTime.now());
    await NumberFactureApi().insertData(numberFactureModel);
  }

  Future<void> venteHisotory() async {
    for (var item in listDataCart) {
      double priceTotal = 0;
      if (double.parse(item.quantityCart) >= double.parse(item.qtyRemise)) {
        priceTotal =
            double.parse(item.quantityCart) * double.parse(item.remise);
      } else {
        priceTotal =
            double.parse(item.quantityCart) * double.parse(item.priceCart);
      }
      final venteCartModel = VenteCartModel(
          idProductCart: item.idProductCart,
          quantityCart: item.quantityCart,
          priceTotalCart: priceTotal.toString(),
          unite: item.unite,
          tva: item.tva,
          remise: item.remise,
          qtyRemise: item.qtyRemise,
          succursale: item.succursale,
          signature: item.signature,
          created: item.created);
      await VenteCartApi().insertData(venteCartModel);
    }
  }

  Future<void> gainVentes() async {
    for (var item in listDataCart) {
      double gainTotal = 0;
      if (double.parse(item.quantityCart) >= double.parse(item.qtyRemise)) {
        gainTotal =
            (double.parse(item.remise) - double.parse(item.priceAchatUnit)) *
                double.parse(item.quantityCart);
      } else {
        gainTotal =
            (double.parse(item.priceCart) - double.parse(item.priceAchatUnit)) *
                double.parse(item.quantityCart);
      }
      final gainModel = GainModel(
          sum: gainTotal,
          succursale: item.succursale,
          signature: item.signature,
          created: item.created);
      await GainApi().insertData(gainModel);
    }
  }
}
