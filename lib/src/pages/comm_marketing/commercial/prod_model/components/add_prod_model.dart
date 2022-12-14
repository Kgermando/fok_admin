import 'package:fokad_admin/src/utils/loading.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/produit_model_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddProModel extends StatefulWidget {
  const AddProModel({Key? key}) : super(key: key);

  @override
  State<AddProModel> createState() => _AddProModelState();
}

class _AddProModelState extends State<AddProModel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Future<List<ProductModel>> dataFuture;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController categorieController = TextEditingController();
  TextEditingController sousCategorie1Controller = TextEditingController();
  TextEditingController sousCategorie2Controller = TextEditingController();
  TextEditingController sousCategorie3Controller = TextEditingController();
  TextEditingController uniteController =
      TextEditingController(); // sousCategorie4

  @override
  initState() {
    getData();
    dataFuture = getDataFuture();
    super.initState();
  }

  @override
  void dispose() {
    categorieController.dispose();
    sousCategorie1Controller.dispose();
    sousCategorie2Controller.dispose();
    sousCategorie3Controller.dispose();
    uniteController.dispose();

    super.dispose();
  }

  String signature = "";
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
    });
  }

  Future<List<ProductModel>> getDataFuture() async {
    var products = await ProduitModelApi().getAllData();
    return products;
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
                          child: FutureBuilder<List<ProductModel>>(
                              future: dataFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ProductModel>> snapshot) {
                                if (snapshot.hasData) {
                                  List<ProductModel>? data = snapshot.data;
                                  return SingleChildScrollView(
                                    child: addPageWidget(data!),
                                  );
                                } else {
                                  return Center(child: loadingMega());
                                }
                              }))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget(List<ProductModel> data) {
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
                    TitleWidget(
                        title: Responsive.isDesktop(context)
                            ? "Ajout un mod??le produit"
                            : "Add Prod Model"),
                    const SizedBox(
                      height: p20,
                    ),
                    categorieWidget(data),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              sousCategorie1Widget(data),
                              sousCategorie2Widget(data)
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: sousCategorie1Widget(data)),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: sousCategorie2Widget(data))
                            ],
                          ),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              sousCategorie3Widget(data),
                              sousCategorie4Widget(data)
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: sousCategorie3Widget(data)),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: sousCategorie4Widget(data))
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

  Widget categorieWidget(List<ProductModel> data) {
    List<String> suggestionList = data.map((e) => e.categorie).toSet().toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          controller: categorieController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Categorie",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget sousCategorie1Widget(List<ProductModel> data) {
    List<String> suggestionList =
        data.map((e) => e.sousCategorie1).toSet().toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          controller: sousCategorie1Controller,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Sous Categorie 1",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget sousCategorie2Widget(List<ProductModel> data) {
    List<String> suggestionList =
        data.map((e) => e.sousCategorie2).toSet().toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          controller: sousCategorie2Controller,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Sous Categorie 2",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget sousCategorie3Widget(List<ProductModel> data) {
    List<String> suggestionList =
        data.map((e) => e.sousCategorie3).toSet().toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          controller: sousCategorie3Controller,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Sous Categorie 3",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget sousCategorie4Widget(List<ProductModel> data) {
    List<String> suggestionList =
        data.map((e) => e.sousCategorie4).toSet().toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          controller: uniteController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Unit??",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
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
    final idProductform =
        "${categorieController.text}-${sousCategorie1Controller.text}-${sousCategorie2Controller.text}-${sousCategorie3Controller.text}-${uniteController.text}";
    final productModel = ProductModel(
        categorie: categorieController.text,
        sousCategorie1: (sousCategorie1Controller.text == "")
            ? '-'
            : sousCategorie1Controller.text,
        sousCategorie2: (sousCategorie2Controller.text == "")
            ? '-'
            : sousCategorie2Controller.text,
        sousCategorie3: (sousCategorie3Controller.text == "")
            ? '-'
            : sousCategorie3Controller.text,
        sousCategorie4:
            (uniteController.text == "") ? '-' : sousCategorie3Controller.text,
        idProduct: idProductform,
        signature: signature,
        created: DateTime.now(),
        approbationDD: 'Approved',
        motifDD: '-',
        signatureDD: '-');
    await ProduitModelApi().insertData(productModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succ??s!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
