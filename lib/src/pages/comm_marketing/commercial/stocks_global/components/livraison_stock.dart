import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/bon_livraison_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/bon_livraison.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class LivraisonStock extends StatefulWidget {
  const LivraisonStock({Key? key, required this.stocksGlobalMOdel})
      : super(key: key);
  final StocksGlobalMOdel stocksGlobalMOdel;

  @override
  State<LivraisonStock> createState() => _LivraisonStockState();
}

class _LivraisonStockState extends State<LivraisonStock> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<SuccursaleModel> succursaleList = [];

  String? quantityStock;
  double remise = 0.0;
  double qtyRemise = 0.0;
  double prixVenteUnit = 0.0;
  String? succursale;

  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerPrixVenteUnit = TextEditingController();

  @override
  void initState() {
    getData();
    setState(() {
      controllerPrixVenteUnit =
          TextEditingController(text: widget.stocksGlobalMOdel.prixVenteUnit);
    });
    super.initState();
  }

  @override
  void dispose() {
    controllerQuantity.dispose();
    controllerPrixVenteUnit.dispose();
    super.dispose();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    List<SuccursaleModel>? succursales = await SuccursaleApi().getAllData();
    setState(() {
      user = userModel;
      succursaleList = succursales
          .where((element) =>
              element.approbationDD == "Approved" &&
              element.approbationDG == "Approved")
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!Responsive.isMobile(context))
                            SizedBox(
                              width: p20,
                              child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back)),
                            ),
                          const SizedBox(width: p10),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: Responsive.isDesktop(context)
                                      ? 'Commercial & Marketing'
                                      : 'Comm. & Mark.',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: addPageWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget() {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitleWidget(title: "Livraison à $succursale"),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    succursaleField(),
                    quantityField(),
                    prixVenteField(),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              qtyRemiseField(),
                              remiseField(),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: qtyRemiseField(),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                child: remiseField(),
                              )
                            ],
                          ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Livré à $succursale',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit();
                            form.reset();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget succursaleField() {
    var succ = succursaleList.map((e) => e.name).toList().toSet();
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Selectionner la succursale',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: succursale,
        isExpanded: true,
        items: succ.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select succursalee" : null,
        onChanged: (value) {
          setState(() {
            succursale = value;
          });
        },
      ),
    );
  }

  Widget quantityField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              // controller: controllerQuantity, // Ce champ doit etre vide pour permettre a l'admin de saisir la qty
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Quantité à livrer',
                suffixStyle: const TextStyle(color: Colors.red),
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'La Qtés à livrer est obligatoire';
                } else if (value.isEmpty) {
                  return 'Qté ne peut pas être nulle';
                } else if (value.contains(RegExp(r'[A-Z]'))) {
                  return 'Que les chiffres svp!';
                } else if (double.parse(value) >
                    double.parse(widget.stocksGlobalMOdel.quantity)) {
                  return 'La Qté à livrer ne peut pas être superieur à la Qtés actuelle';
                }
                return null;
              },
              onChanged: (value) => setState(() => quantityStock = value),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Text(
                    'Qté Existante: ${widget.stocksGlobalMOdel.quantity} ${widget.stocksGlobalMOdel.unite}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.orange)),
              ))
        ],
      ),
    );
  }

  Widget prixVenteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controllerPrixVenteUnit,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Prix de vente unitaire',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le Prix de vente unitaires est obligatoire';
                }
                return null;
              },
              onChanged: (value) => setState(() {
                prixVenteUnit = (value == "") ? 0.0 : double.parse(value);
              }),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Text(
                    'Prix Existant: ${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.prixVenteUnit).toStringAsFixed(2)))} \$',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.orange)),
              ))
        ],
      ),
    );
  }

  Widget remiseField() {
    return Responsive.isMobile(context)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  // controller: priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Remise en % (Facultatif) ',
                    // hintText: 'Mettez "1" si vide',
                    labelStyle: const TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                      return 'chiffres obligatoire';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) => setState(() {
                    remise = (value == "") ? 1 : double.parse(value);
                  }),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              remiseValeur()
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    // controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Remise en % (Facultatif) ',
                      // hintText: 'Mettez "1" si vide',
                      labelStyle: const TextStyle(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                        return 'chiffres obligatoire';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) => setState(() {
                      remise = (value == "") ? 1 : double.parse(value);
                    }),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: remiseValeur(),
              )
            ],
          );
  }

  Widget qtyRemiseField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: 'Quantités pour la remise (Facultatif) ',
          // hintText: 'Mettez "1" si vide',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (RegExpIsValide().isValideVente.hasMatch(value!)) {
            return 'chiffres obligatoire';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          qtyRemise = (value == "") ? 1 : double.parse(value);
        }),
      ),
    );
  }

  double? pavTVARemise;

  remiseValeur() {
    var remiseEnPourcent = (prixVenteUnit * remise) / 100;
    pavTVARemise = prixVenteUnit - remiseEnPourcent;
    return Container(
      margin: const EdgeInsets.only(left: 5.0, bottom: 20.0),
      child: Text('R: ${pavTVARemise!.toStringAsFixed(2)} \$',
          style: Theme.of(context).textTheme.headline6),
    );
  }

  // Livraison vers succursale
  void submit() async {
    var qtyRestanteStockGlobal =
        double.parse(widget.stocksGlobalMOdel.quantity) -
            double.parse(quantityStock.toString());

    var remisePourcent =
        (prixVenteUnit * double.parse(remise.toString())) / 100;
    var remisePourcentToMontant = prixVenteUnit - remisePourcent;

    // Update quantity stock global
    final stocksGlobalMOdel = StocksGlobalMOdel(
        id: widget.stocksGlobalMOdel.id!,
        idProduct: widget.stocksGlobalMOdel.idProduct,
        quantity: qtyRestanteStockGlobal.toString(),
        quantityAchat: widget.stocksGlobalMOdel.quantityAchat,
        priceAchatUnit: widget.stocksGlobalMOdel.priceAchatUnit,
        prixVenteUnit: widget.stocksGlobalMOdel.prixVenteUnit,
        unite: widget.stocksGlobalMOdel.unite,
        modeAchat: widget.stocksGlobalMOdel.modeAchat,
        tva: widget.stocksGlobalMOdel.tva,
        qtyRavitailler: widget.stocksGlobalMOdel.qtyRavitailler,
        signature: widget.stocksGlobalMOdel.signature,
        created: widget.stocksGlobalMOdel.created);
    await StockGlobalApi().updateData(stocksGlobalMOdel);

    // Generer le bon de livraison pour la succursale
    final bonLivraisonModel = BonLivraisonModel(
        idProduct: widget.stocksGlobalMOdel.idProduct,
        quantityAchat: quantityStock.toString(),
        priceAchatUnit: widget.stocksGlobalMOdel.priceAchatUnit,
        prixVenteUnit: prixVenteUnit.toString(),
        unite: widget.stocksGlobalMOdel.unite,
        firstName: user!.prenom.toString(),
        lastName: user!.nom.toString(),
        tva: widget.stocksGlobalMOdel.tva,
        remise: remisePourcentToMontant.toString(),
        qtyRemise: qtyRemise.toString(),
        accuseReception: 'false',
        accuseReceptionFirstName: '-',
        accuseReceptionLastName: '-',
        succursale: succursale.toString(),
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await BonLivraisonApi().insertData(bonLivraisonModel).then((value) {
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${bonLivraisonModel.idProduct} livré!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
