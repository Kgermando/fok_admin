import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';

class AddStockGlobal extends StatefulWidget {
  const AddStockGlobal({Key? key}) : super(key: key);

  @override
  State<AddStockGlobal> createState() => _AddStockGlobalState();
}

class _AddStockGlobalState extends State<AddStockGlobal> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<ProductModel> idProductDropdown = [];

  List<StocksGlobalMOdel> stocksGlobalList = [];

  final List<String> unites = Dropdown().unites;

  String? idProduct;
  String quantityAchat = '0.0';
  String priceAchatUnit = '0.0';
  double prixVenteUnit = 0.0;
  // String? unite;
  bool modeAchat = true;
  String modeAchatBool = "False";
  DateTime? date;
  String? telephone;
  String? succursale;
  String? nameBusiness;
  double tva = 0.0;

  @override
  initState() {
    getData();
    super.initState();
  }

  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var produitModel = await ProduitModelApi().getAllData();
    var stockGlobal = await StockGlobalApi().getAllData();

    if (!mounted) return;
    setState(() {
      signature = userModel.matricule;
      idProductDropdown = produitModel
          .where((element) => element.approbationDD == "Approved")
          .toList();
      stocksGlobalList = stockGlobal;
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
                    const TitleWidget(title: "Ajout stock global"),
                    const SizedBox(
                      height: p10,
                    ),
                    Row(
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
                    idProductField(),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              quantityAchatField(),
                              priceAchatUnitField(),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: quantityAchatField(),
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
                        title: 'Soumettre',
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
          onToggle: (val) {
            setState(() {
              modeAchat = val;
              if (modeAchat == true) {
                modeAchatBool = "true";
              } else {
                modeAchatBool = "false";
              }
            });
          },
        ));
  }

  Widget idProductField() {
    List<String> prod = [];
    List<String> stocks = [];
    List<String> catList = [];

    prod = idProductDropdown.map((e) => e.idProduct).toSet().toList();
    stocks = stocksGlobalList.map((e) => e.idProduct).toSet().toList();

    catList = prod.toSet().difference(stocks.toSet()).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Identifiant du produit',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: idProduct,
        isExpanded: true,
        // style: const TextStyle(color: Colors.deepPurple),
        items: catList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (produit) {
          setState(() {
            idProduct = produit;
          });
        },
      ),
    );
  }

  Widget quantityAchatField() {
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            labelText: 'Quantités entrant',
            labelStyle: const TextStyle(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'La Quantité total est obligatoire';
            } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
              return 'chiffres obligatoire';
            } else {
              return null;
            }
          },
          onChanged: (value) => setState(() {
            quantityAchat = value.trim();
          }),
        ));
  }

  Widget priceAchatUnitField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: 'Prix d\'achat unitaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Le Prix total d\'achat est obligatoire';
          } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
            return 'chiffres obligatoire';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          priceAchatUnit = value.trim();
        }),
      ),
    );
  }

  Widget prixVenteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
          prixVenteUnit = (value == "") ? 1 : double.parse(value);
        }),
      ),
    );
  }

  Widget tvaField() {
    return Responsive.isDesktop(context)
        ? Row(
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
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
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
                child: tvaValeur(),
              )
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: 'TVA en %',
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
              const SizedBox(
                width: 10.0,
              ),
              tvaValeur()
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

  Future<void> submit() async {
    var uniteProd = idProduct!.split('-');
    var unite = uniteProd.elementAt(4);
    final stocksGlobalMOdel = StocksGlobalMOdel(
        idProduct: idProduct.toString(),
        quantity: quantityAchat.toString(),
        quantityAchat: quantityAchat.toString(),
        priceAchatUnit: priceAchatUnit.toString(),
        prixVenteUnit: prixVenteUnit.toString(),
        unite: unite.toString(),
        modeAchat: modeAchatBool,
        tva: tva.toString(),
        qtyRavitailler: quantityAchat.toString(),
        signature: signature.toString(),
        created: DateTime.now());
    await StockGlobalApi().insertData(stocksGlobalMOdel).then((value) {
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${stocksGlobalMOdel.idProduct} ajouté!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
