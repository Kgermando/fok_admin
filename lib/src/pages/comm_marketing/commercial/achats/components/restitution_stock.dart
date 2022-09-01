import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/restitution_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/restitution_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';

class RestitutionStock extends StatefulWidget {
  const RestitutionStock({Key? key, required this.achat}) : super(key: key);
  final AchatModel achat;

  @override
  State<RestitutionStock> createState() => _RestitutionStockState();
}

class _RestitutionStockState extends State<RestitutionStock> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  double quantityStock = 0.0;

  List<StocksGlobalMOdel> stockGlobal = [];

  @override
  void initState() {
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
  void getData() async {
    UserModel userModel = await AuthApi().getUserId();
    List<StocksGlobalMOdel>? data = await StockGlobalApi().getAllData();
    setState(() {
      user = userModel;
      stockGlobal = data
          .where((element) => element.idProduct == widget.achat.idProduct)
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
                    child: Column(
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
                            child: Scrollbar(
                                controller: _controllerScroll,
                                child: addPageWidget()))
                      ],
                    )),
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
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                child: ListView(
                  controller: _controllerScroll,
                  padding: const EdgeInsets.all(p20),
                  children: [
                    const TitleWidget(title: "Restitution Produit"),
                    const SizedBox(height: p20),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              Text("Produit :",
                                  style: bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade700)),
                              Text(widget.achat.idProduct,
                                  style: bodyLarge.copyWith(
                                      color: Colors.red.shade700))
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Produit :",
                                      style: bodyLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade700))),
                              Expanded(
                                  flex: 3,
                                  child: Text(widget.achat.idProduct,
                                      style: bodyLarge.copyWith(
                                          color: Colors.red.shade700))),
                            ],
                          ),
                    const SizedBox(
                      height: p20,
                    ),
                    quantityField(),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            transfertProduit();
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

  Widget textField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      child: Text(
        widget.achat.idProduct,
        style: Responsive.isDesktop(context)
            ? Theme.of(context).textTheme.headline5
            : Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget quantityField() {
    return Responsive.isDesktop(context)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    // controller: controllerQuantity, // Ce champ doit etre vide pour permettre a l'admin de saisir la qty
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      labelText:
                          'Qtés disponible est de ${widget.achat.quantity} ${widget.achat.unite}',
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
                        return 'Qtés ne peut pas être nulle';
                      } else if (value.contains(RegExp(r'[A-Z]'))) {
                        return 'Que les chiffres svp!';
                      } else if (double.parse(value) >
                          double.parse(double.parse(widget.achat.quantity)
                              .toStringAsFixed(0))) {
                        return 'La Qtés à livrer ne peut pas être superieur à la Qtés actuelle';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      quantityStock = (value == "") ? 0.0 : double.parse(value);
                    }),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: qtyRestanteWidget(),
              )
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  // controller: controllerQuantity, // Ce champ doit etre vide pour permettre a l'admin de saisir la qty
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText:
                        'Qtés disponible est de ${widget.achat.quantity} ${widget.achat.unite}',
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
                      return 'Qtés ne peut pas être nulle';
                    } else if (value.contains(RegExp(r'[A-Z]'))) {
                      return 'Que les chiffres svp!';
                    } else if (double.parse(value) >
                        double.parse(widget.achat.quantity)) {
                      return 'La Qtés à livrer ne peut pas être superieur à la Qtés actuelle';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {
                    quantityStock = (value == "") ? 0.0 : double.parse(value);
                  }),
                ),
              ),
              qtyRestanteWidget()
            ],
          );
  }

  double? qtyRestante;
  Widget qtyRestanteWidget() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    qtyRestante = double.parse(widget.achat.quantity) - quantityStock;

    return Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
        child: Text(
            'Reste: ${qtyRestante!.toStringAsFixed(2)} ${widget.achat.unite}',
            style: bodyText1));
  }

  Future<void> transfertProduit() async {
    qtyRestante = double.parse(widget.achat.quantity) - quantityStock;

    final restitutionModel = RestitutionModel(
        idProduct: widget.achat.idProduct,
        quantity: quantityStock.toString(),
        unite: widget.achat.unite,
        firstName: user.nom.toString(),
        lastName: user.prenom.toString(),
        accuseReception: 'false',
        accuseReceptionFirstName: '-',
        accuseReceptionLastName: '-',
        role: user.role,
        succursale: user.succursale,
        signature: user.matricule,
        created: DateTime.now());
    await RestitutionApi().insertData(restitutionModel);

    // Update AchatModel
    final achatModel = AchatModel(
        id: widget.achat.id!,
        idProduct: widget.achat.idProduct,
        quantity: qtyRestante!.toString(),
        quantityAchat: widget.achat.quantityAchat,
        priceAchatUnit: widget.achat.priceAchatUnit,
        prixVenteUnit: widget.achat.prixVenteUnit,
        unite: widget.achat.unite,
        tva: widget.achat.tva,
        remise: widget.achat.remise,
        qtyRemise: widget.achat.qtyRemise,
        qtyLivre: widget.achat.qtyLivre,
        succursale: widget.achat.succursale,
        signature: widget.achat.signature,
        created: widget.achat.created);
    await AchatApi().updateData(achatModel).then((value) {
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${value.idProduct} transferé!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
