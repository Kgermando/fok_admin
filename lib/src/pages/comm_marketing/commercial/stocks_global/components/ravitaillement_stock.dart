import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/history_rabitaillement_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/history_ravitaillement_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

class RavitailleemntStock extends StatefulWidget {
  const RavitailleemntStock({Key? key, required this.stocksGlobalMOdel})
      : super(key: key);
  final StocksGlobalMOdel stocksGlobalMOdel;

  @override
  State<RavitailleemntStock> createState() => _RavitailleemntStockState();
}

class _RavitailleemntStockState extends State<RavitailleemntStock> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> unites = Dropdown().unites;
  List<ProductModel> idProductDropdown = [];

  int? id;
  String? quantity;
  String? priceAchatUnit;
  double prixVenteUnit = 0.0;
  double tva = 0.0;
  bool modeAchat = true;
  String modeAchatBool = "False";
  DateTime? date;
  String? telephone;
  String? succursale;
  String? nameBusiness;

  TextEditingController controlleridProduct = TextEditingController();
  TextEditingController controllerquantity = TextEditingController();
  // TextEditingController controllerQuantityAchat = TextEditingController();
  TextEditingController controllerpriceAchatUnit = TextEditingController();
  TextEditingController controllerPrixVenteUnit = TextEditingController();
  TextEditingController controllerUnite = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    loadProdModel();
    setState(() {
      modeAchatBool = widget.stocksGlobalMOdel.modeAchat;
      controlleridProduct =
          TextEditingController(text: widget.stocksGlobalMOdel.idProduct);
      controllerquantity =
          TextEditingController(text: widget.stocksGlobalMOdel.quantity);
      controllerpriceAchatUnit =
          TextEditingController(text: widget.stocksGlobalMOdel.priceAchatUnit);
      controllerPrixVenteUnit =
          TextEditingController(text: widget.stocksGlobalMOdel.prixVenteUnit);
      controllerUnite =
          TextEditingController(text: widget.stocksGlobalMOdel.unite);
    });
  }

  @override
  void dispose() {
    controlleridProduct.dispose();
    controllerquantity.dispose();
    controllerpriceAchatUnit.dispose();
    controllerPrixVenteUnit.dispose();
    controllerUnite.dispose();
    super.dispose();
  }

  void loadProdModel() async {
    List<ProductModel>? achatDB = await ProduitModelApi().getAllData();
    if (!mounted) return;
    setState(() {
      idProductDropdown = achatDB;
    });
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
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
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              Text('Mode achat :',
                                  textAlign: TextAlign.start,
                                  style: bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              modeAchatField()
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Text('Mode achat :',
                                    textAlign: TextAlign.start,
                                    style: bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: modeAchatField())
                            ],
                          ),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              quantityField(),
                              priceAchatUnitField(),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: quantityField(),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                child: priceAchatUnitField(),
                              )
                            ],
                          ),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              prixVenteField(),
                              tvaField(),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: prixVenteField(),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                child: tvaField(),
                              )
                            ],
                          ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Ravitailler',
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

  Widget modeAchatField() {
    if (modeAchatBool == "true") {
      modeAchat = true;
    } else if (modeAchatBool == "false") {
      modeAchat = false;
    }
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: FlutterSwitch(
          width: Responsive.isDesktop(context) ? 225.0 : 150,
          height: 55.0,
          inactiveColor: Colors.red,
          valueFontSize: 25.0,
          toggleSize: 45.0,
          value: modeAchat,
          borderRadius: 30.0,
          padding: 8.0,
          showOnOff: true,
          activeText: 'PAYE',
          inactiveText: 'NON PAYE',
          onToggle: (value) {
            setState(() {
              modeAchat = value;
              if (modeAchat == true) {
                modeAchatBool = "true";
              } else {
                modeAchatBool = "false";
              }
            });
          },
        ));
  }

  Widget quantityField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controllerquantity,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Quantités',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (quantity) => quantity != null && quantity.isEmpty
                  ? 'La Quantité total est obligatoire'
                  : null,
              onChanged: (value) => setState(() => controllerquantity.text),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Quantité précédent"),
                    Text(
                        "${widget.stocksGlobalMOdel.quantity} ${widget.stocksGlobalMOdel.unite} \$",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget priceAchatUnitField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controllerpriceAchatUnit,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Prix d\'achats unitaire',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) => value != null && value.isEmpty
                  ? 'Le prix d\'achat unitaire est obligatoire'
                  : null,
              onChanged: (value) =>
                  setState(() => controllerpriceAchatUnit.text),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Prix d'achat précédent"),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.priceAchatUnit).toStringAsFixed(2)))} \$",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
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
                if (value != null && value.isEmpty) {
                  return 'Le Prix de vente unitaires est obligatoire';
                } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                  return 'chiffres obligatoire';
                } else {
                  return null;
                }
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
                child: Column(
                  children: [
                    const Text("Prix de vente précédent"),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.prixVenteUnit).toStringAsFixed(2)))} \$",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget tvaField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'TVA en %',
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
                tva = (value == "") ? 1 : double.parse(value);
              }),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 1,
          child: tvaValeur(),
        )
      ],
    );
  }

  double? pavTVA;

  tvaValeur() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    var pvau = prixVenteUnit * tva / 100;

    pavTVA = prixVenteUnit + pvau;

    return Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
        child: Text('PVU: ${pavTVA!.toStringAsFixed(2)} \$', style: bodyText1));
  }

  // HIstorique de ravitaillement
  void submit() async {
    var qtyDisponible = double.parse(controllerquantity.text) +
        double.parse(widget.stocksGlobalMOdel.quantity);

    // Add Achat history pour voir les entrés et sorties de chaque produit
    var qtyDifference = double.parse(widget.stocksGlobalMOdel.quantityAchat) -
        double.parse(widget.stocksGlobalMOdel.quantity);
    var priceDifference =
        pavTVA! - double.parse(widget.stocksGlobalMOdel.priceAchatUnit);
    var margeBenMap = qtyDifference * priceDifference;

    final historyRavitaillementModel = HistoryRavitaillementModel(
        idProduct: widget.stocksGlobalMOdel.idProduct,
        quantity: widget.stocksGlobalMOdel.quantity,
        quantityAchat: widget.stocksGlobalMOdel.quantityAchat,
        priceAchatUnit: widget.stocksGlobalMOdel.priceAchatUnit,
        prixVenteUnit: widget.stocksGlobalMOdel.prixVenteUnit,
        unite: widget.stocksGlobalMOdel.unite,
        margeBen: margeBenMap.toString(),
        tva: widget.stocksGlobalMOdel.tva,
        qtyRavitailler: widget.stocksGlobalMOdel.qtyRavitailler,
        succursale: user!.succursale,
        signature: user!.matricule.toString(),
        created: widget.stocksGlobalMOdel.created);
    await HistoryRavitaillementApi().insertData(historyRavitaillementModel);

    // Update Achat stock global
    final stocksGlobalMOdel = StocksGlobalMOdel(
        id: widget.stocksGlobalMOdel.id!,
        idProduct: widget.stocksGlobalMOdel.idProduct,
        quantity: qtyDisponible.toString(),
        quantityAchat: qtyDisponible.toString(),
        priceAchatUnit: controllerpriceAchatUnit.text,
        prixVenteUnit: pavTVA.toString(),
        unite: widget.stocksGlobalMOdel.unite,
        modeAchat: modeAchat.toString(),
        tva: tva.toString(),
        qtyRavitailler: widget.stocksGlobalMOdel.qtyRavitailler,
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await StockGlobalApi().updateData(stocksGlobalMOdel).then((value) {
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${stocksGlobalMOdel.idProduct} mis à jour!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
