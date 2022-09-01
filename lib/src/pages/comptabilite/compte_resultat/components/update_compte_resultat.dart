import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_resultat_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_resultat_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class UpdateCompteResultat extends StatefulWidget {
  const UpdateCompteResultat({Key? key, required this.compteResulatsModel})
      : super(key: key);
  final CompteResulatsModel compteResulatsModel;

  @override
  State<UpdateCompteResultat> createState() => _UpdateCompteResultatState();
}

class _UpdateCompteResultatState extends State<UpdateCompteResultat> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController intituleController = TextEditingController();
  TextEditingController achatMarchandisesController = TextEditingController();
  TextEditingController variationStockMarchandisesController =
      TextEditingController();
  TextEditingController achatApprovionnementsController =
      TextEditingController();
  TextEditingController variationApprovionnementsController =
      TextEditingController();
  TextEditingController autresChargesExterneController =
      TextEditingController();
  TextEditingController impotsTaxesVersementsAssimilesController =
      TextEditingController();
  TextEditingController renumerationPersonnelController =
      TextEditingController();
  TextEditingController chargesSocialasController = TextEditingController();
  TextEditingController dotatiopnsProvisionsController =
      TextEditingController();
  TextEditingController autresChargesController = TextEditingController();
  TextEditingController chargesfinancieresController = TextEditingController();
  TextEditingController chargesExptionnellesController =
      TextEditingController();
  TextEditingController impotSurbeneficesController = TextEditingController();
  TextEditingController soldeCrediteurController = TextEditingController();
  TextEditingController ventesMarchandisesController = TextEditingController();

  TextEditingController productionVendueBienEtSericesController =
      TextEditingController();
  TextEditingController productionStockeeController = TextEditingController();
  TextEditingController productionImmobiliseeController =
      TextEditingController();
  TextEditingController subventionExploitationController =
      TextEditingController();
  TextEditingController autreProduitsController = TextEditingController();
  TextEditingController montantExportationController = TextEditingController();
  TextEditingController produitfinancieresController = TextEditingController();
  TextEditingController produitExceptionnelsController =
      TextEditingController();
  TextEditingController soldeDebiteurController = TextEditingController();

  @override
  void initState() {
    getData();
    setState(() {
      intituleController =
          TextEditingController(text: widget.compteResulatsModel.intitule);
      achatMarchandisesController = TextEditingController(
          text: widget.compteResulatsModel.achatMarchandises);
      variationStockMarchandisesController = TextEditingController(
          text: widget.compteResulatsModel.variationStockMarchandises);
      achatApprovionnementsController = TextEditingController(
          text: widget.compteResulatsModel.achatApprovionnements);
      variationApprovionnementsController = TextEditingController(
          text: widget.compteResulatsModel.variationApprovionnements);
      autresChargesExterneController = TextEditingController(
          text: widget.compteResulatsModel.autresChargesExterne);
      chargesfinancieresController = TextEditingController(
          text: widget.compteResulatsModel.chargesfinancieres);
      impotsTaxesVersementsAssimilesController = TextEditingController(
          text: widget.compteResulatsModel.impotsTaxesVersementsAssimiles);
      renumerationPersonnelController = TextEditingController(
          text: widget.compteResulatsModel.renumerationPersonnel);
      chargesSocialasController = TextEditingController(
          text: widget.compteResulatsModel.chargesSocialas);
      dotatiopnsProvisionsController = TextEditingController(
          text: widget.compteResulatsModel.dotatiopnsProvisions);
      autresChargesController =
          TextEditingController(text: widget.compteResulatsModel.autresCharges);
      chargesExptionnellesController = TextEditingController(
          text: widget.compteResulatsModel.chargesExptionnelles);
      impotSurbeneficesController = TextEditingController(
          text: widget.compteResulatsModel.impotSurbenefices);
      soldeCrediteurController = TextEditingController(
          text: widget.compteResulatsModel.soldeCrediteur);
      ventesMarchandisesController = TextEditingController(
          text: widget.compteResulatsModel.ventesMarchandises);

      productionVendueBienEtSericesController = TextEditingController(
          text: widget.compteResulatsModel.productionVendueBienEtSerices);
      productionStockeeController = TextEditingController(
          text: widget.compteResulatsModel.productionStockee);
      productionImmobiliseeController = TextEditingController(
          text: widget.compteResulatsModel.productionImmobilisee);
      subventionExploitationController = TextEditingController(
          text: widget.compteResulatsModel.subventionExploitation);
      autreProduitsController =
          TextEditingController(text: widget.compteResulatsModel.autreProduits);
      montantExportationController = TextEditingController(
          text: widget.compteResulatsModel.montantExportation);
      produitfinancieresController = TextEditingController(
          text: widget.compteResulatsModel.produitfinancieres);
      produitExceptionnelsController = TextEditingController(
          text: widget.compteResulatsModel.produitExceptionnels);
      soldeDebiteurController =
          TextEditingController(text: widget.compteResulatsModel.soldeDebiteur);
    });

    super.initState();
  }

  @override
  void dispose() {
    intituleController.dispose();
    achatMarchandisesController.dispose();
    variationStockMarchandisesController.dispose();
    achatApprovionnementsController.dispose();
    variationApprovionnementsController.dispose();
    autresChargesExterneController.dispose();
    impotsTaxesVersementsAssimilesController.dispose();
    renumerationPersonnelController.dispose();
    chargesSocialasController.dispose();
    dotatiopnsProvisionsController.dispose();
    autresChargesController.dispose();
    chargesfinancieresController.dispose();
    chargesExptionnellesController.dispose();
    impotSurbeneficesController.dispose();
    soldeCrediteurController.dispose();
    ventesMarchandisesController.dispose();
    productionVendueBienEtSericesController.dispose();
    productionStockeeController.dispose();
    productionImmobiliseeController.dispose();
    subventionExploitationController.dispose();
    autreProduitsController.dispose();
    montantExportationController.dispose();
    produitfinancieresController.dispose();
    produitExceptionnelsController.dispose();
    soldeDebiteurController.dispose();

    super.dispose();
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
                              child: CustomAppbar(
                                  title: 'Comptabilités',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(child: addPageWidget()))
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
      width = MediaQuery.of(context).size.width / 1.5;
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
            child: Container(
              margin: const EdgeInsets.all(p16),
              padding: const EdgeInsets.all(p16),
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(p10),
                border: Border.all(
                  color: mainColor,
                  width: 2.0,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleWidget(title: "Compte resultats"),
                      Row(
                        children: [PrintWidget(onPressed: () {})],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: p20,
                  ),
                  intituleWidget(),
                  const SizedBox(
                    height: p20,
                  ),
                  chargesWidget(),
                  const SizedBox(
                    height: p20,
                  ),
                  produitWidget(),
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
        ],
      ),
    );
  }

  Widget chargesWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: mainColor),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Charges (Hors taxes)",
              style: bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: p30),
          Column(
            children: [
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        achatMarchandisesWidget(),
                        variationStockMarchandisesWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: achatMarchandisesWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: variationStockMarchandisesWidget())
                      ],
                    ),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        achatApprovionnementsWidget(),
                        variationApprovionnementsWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: achatApprovionnementsWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: variationApprovionnementsWidget())
                      ],
                    ),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        autresChargesExterneWidget(),
                        impotsTaxesVersementsAssimilesWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: autresChargesExterneWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: impotsTaxesVersementsAssimilesWidget())
                      ],
                    ),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        renumerationPersonnelWidget(),
                        chargesSocialasWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: renumerationPersonnelWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: chargesSocialasWidget())
                      ],
                    ),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        dotatiopnsProvisionsWidget(),
                        autresChargesWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: dotatiopnsProvisionsWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: autresChargesWidget())
                      ],
                    ),
              chargesfinancieresWidget(),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        chargesExptionnellesWidget(),
                        importSurbeneficesWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: chargesExptionnellesWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: importSurbeneficesWidget())
                      ],
                    ),
              soldeCrediteurWidget()
            ],
          ),
        ],
      ),
    );
  }

  Widget intituleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: intituleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Intitulé',
            hintText: 'intitule',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget achatMarchandisesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: achatMarchandisesController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Achats Marchandises',
            hintText: 'Achats Marchandises',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget variationStockMarchandisesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: variationStockMarchandisesController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Variation Stocks Marchandises',
            hintText: 'Variation Stocks Marchandises',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget achatApprovionnementsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: achatApprovionnementsController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Achats Approvionnements',
            hintText: 'Achats Approvionnements',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget variationApprovionnementsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: variationApprovionnementsController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Variation Approvionnements',
            hintText: 'Variation Approvionnements',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget autresChargesExterneWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: autresChargesExterneController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Autres Charges Externe',
            hintText: 'Autres Charges Externe',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget impotsTaxesVersementsAssimilesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: impotsTaxesVersementsAssimilesController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Impôts Taxes Versements Assimiles',
            hintText: 'Impôts Taxes Versements Assimiles',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget renumerationPersonnelWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: renumerationPersonnelController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Renumeration du Personnel',
            hintText: 'Renumeration du Personnel',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget chargesSocialasWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: chargesSocialasController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Charges Sociales',
            hintText: 'Charges Sociales',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget dotatiopnsProvisionsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: dotatiopnsProvisionsController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Dotations Provisions',
            hintText: 'Dotations Provisions',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget autresChargesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: autresChargesController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Autres Charges',
            hintText: 'Autres Charges',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget chargesfinancieresWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: chargesfinancieresController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Charges financieres',
            hintText: 'Charges financieres',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget chargesExptionnellesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: chargesExptionnellesController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Charges Exptionnelles',
            hintText: 'Charges Exptionnelles',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget importSurbeneficesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: impotSurbeneficesController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Impôt Sur le benefices',
            hintText: 'Impôt Sur le benefices',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget soldeCrediteurWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: soldeCrediteurController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Solde Crediteur',
            hintText: 'Solde Crediteur',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget ventesMarchandisesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: ventesMarchandisesController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Ventes Marchandises',
            hintText: 'Ventes Marchandises',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget produitWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Container(
      padding: const EdgeInsets.only(top: p16, bottom: p16),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0, color: mainColor),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Produits (Hors taxes)",
              style: bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: p30),
          Column(
            children: [
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        ventesMarchandisesWidget(),
                        productionVendueBienEtSericesWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: ventesMarchandisesWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: productionVendueBienEtSericesWidget())
                      ],
                    ),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        productionStockeeWidget(),
                        productionImmobiliseeWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: productionStockeeWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: productionImmobiliseeWidget())
                      ],
                    ),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        subventionExploitationWidget(),
                        autreProduitsWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: subventionExploitationWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: autreProduitsWidget())
                      ],
                    ),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        produitfinancieresWidget(),
                        montantExportationWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: produitfinancieresWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: montantExportationWidget())
                      ],
                    ),
              Responsive.isMobile(context)
                  ? Column(
                      children: [
                        produitExceptionnelsWidget(),
                        soldeDebiteurWidget()
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: produitExceptionnelsWidget()),
                        const SizedBox(height: p20),
                        Expanded(child: soldeDebiteurWidget())
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget productionVendueBienEtSericesWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: productionVendueBienEtSericesController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Production Vendue Bien et Serices',
            hintText: 'Production Vendue Bien et Serices',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget productionStockeeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: productionStockeeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Production Stockee',
            hintText: 'Production Stockee',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget productionImmobiliseeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: productionImmobiliseeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Production Immobilisée',
            hintText: 'Production Immobilisée',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget subventionExploitationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: subventionExploitationController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Subventions Exploitation',
            hintText: 'Subventions Exploitation',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget autreProduitsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: autreProduitsController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Autres Produits',
            hintText: 'Autres Produits',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget montantExportationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: montantExportationController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Dont à l'Exportation",
            hintText: "Dont à l'xportation",
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget produitfinancieresWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: produitfinancieresController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Produits financieres',
            hintText: 'Produits financieres',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget produitExceptionnelsWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: produitExceptionnelsController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Produit Exceptionnels',
            hintText: 'Produit Exceptionnels',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget soldeDebiteurWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p10, left: p5),
        child: TextFormField(
          controller: soldeDebiteurController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Solde Debiteur',
            hintText: 'Solde Debiteur',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> submit() async {
    final compteResulatsModel = CompteResulatsModel(
        id: widget.compteResulatsModel.id,
        intitule: intituleController.text,
        achatMarchandises: achatMarchandisesController.text,
        variationStockMarchandises: variationStockMarchandisesController.text,
        achatApprovionnements: achatApprovionnementsController.text,
        variationApprovionnements: variationApprovionnementsController.text,
        autresChargesExterne: autresChargesExterneController.text,
        impotsTaxesVersementsAssimiles:
            impotsTaxesVersementsAssimilesController.text,
        renumerationPersonnel: renumerationPersonnelController.text,
        chargesSocialas: chargesSocialasController.text,
        dotatiopnsProvisions: dotatiopnsProvisionsController.text,
        autresCharges: autresChargesController.text,
        chargesfinancieres: chargesfinancieresController.text,
        chargesExptionnelles: chargesExptionnellesController.text,
        impotSurbenefices: impotSurbeneficesController.text,
        soldeCrediteur: soldeCrediteurController.text,
        ventesMarchandises: ventesMarchandisesController.text,
        productionVendueBienEtSerices:
            productionVendueBienEtSericesController.text,
        productionStockee: productionStockeeController.text,
        productionImmobilisee: productionImmobiliseeController.text,
        subventionExploitation: subventionExploitationController.text,
        autreProduits: autreProduitsController.text,
        montantExportation: montantExportationController.text,
        produitfinancieres: produitfinancieresController.text,
        produitExceptionnels: produitExceptionnelsController.text,
        soldeDebiteur: soldeDebiteurController.text,
        signature: user!.matricule.toString(),
        createdRef: widget.compteResulatsModel.createdRef,
        created: DateTime.now(),
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await CompteResultatApi().updateData(compteResulatsModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
