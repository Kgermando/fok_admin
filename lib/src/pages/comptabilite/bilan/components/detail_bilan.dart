
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_bilan_ref_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/bilan_model.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_bilan_ref_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/components/bilan_pdf.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class DetailBilan extends StatefulWidget {
  const DetailBilan({Key? key}) : super(key: key);

  @override
  State<DetailBilan> createState() => _DetailBilanState();
}

class _DetailBilanState extends State<DetailBilan> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Future<List<CompteBilanRefModel>> dataFutureRef;
  bool isLoading = false;
  bool isLoadingDelete = false;
  bool isLoadingSend = false;
  bool isLoadingEditLigne = false;
  bool isLoadingDeleteLigne = false;

  String? comptes;
  TextEditingController montantController = TextEditingController();
  String? type;

  @override
  initState() {
    getData();
    dataFutureRef = getDataFuture();
    super.initState();
  }

  @override
  void dispose() {
    montantController.dispose();
    super.dispose();
  }

  // For PDF
  List<CompteBilanRefModel> compteActifList = [];
  List<CompteBilanRefModel> comptePassifList = [];
  List<CompteBilanRefModel> compteBilanRefFilter = [];

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
    var compteListRef = await CompteBilanRefApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        compteBilanRefFilter = compteListRef;
      });
    }
  }

  Future<List<CompteBilanRefModel>> getDataFuture() async {
    var dataF = await CompteBilanRefApi().getAllData();
    return dataF;
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<BilanModel>(
            future: BilanApi().getOneData(id),
            builder:
                (BuildContext context, AsyncSnapshot<BilanModel> snapshot) {
              if (snapshot.hasData) {
                BilanModel? data = snapshot.data;
                return (data!.isSubmit == 'false' &&
                        data.approbationDD == '-' &&
                        data.approbationDG == '-')
                    ? FloatingActionButton.extended(
                        icon: const Icon(Icons.add),
                        label: const Text("Ecriture"),
                        onPressed: () {
                          newEcritureDialog(data);
                        })
                    : Container();
              } else {
                return loadingMini();
              }
            }),
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
                    child: FutureBuilder<BilanModel>(
                        future: BilanApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<BilanModel> snapshot) {
                          if (snapshot.hasData) {
                            BilanModel? data = snapshot.data;
                            compteActifList = compteBilanRefFilter
                                .where((element) =>
                                    element.reference == data!.id &&
                                    element.type == "Actif")
                                .toList();
                            comptePassifList = compteBilanRefFilter
                                .where((element) =>
                                    element.reference == data!.id &&
                                    element.type == "Passif")
                                .toList();
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
                                          title: "Comptabilités",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      pageDetail(data!),
                                      const SizedBox(height: p10),
                                      // LayoutBuilder(
                                      //     builder: (context, constraints) {
                                      //   if (constraints.maxWidth >= 1100) {
                                      //     return BilanApprobationDesktop(
                                      //         user: user, bilanModel: data);
                                      //   } else if (constraints.maxWidth <
                                      //           1100 &&
                                      //       constraints.maxWidth >= 650) {
                                      //     return BilanApprobationTablet(
                                      //         user: user, bilanModel: data);
                                      //   } else {
                                      //     return BilanApprobationMobile(
                                      //         user: user, bilanModel: data);
                                      //   }
                                      // })
                                    ],
                                  ),
                                ))
                              ],
                            );
                          } else {
                            return Center(child: loadingMega());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(BilanModel data) {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 1.5;
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
                  const TitleWidget(title: "Bilan"),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              tooltip: "Actualiser la page",
                              color: Colors.green,
                              onPressed: () {
                                setState(() {
                                  dataFutureRef = getDataFuture();
                                });
                              },
                              icon: const Icon(Icons.refresh)),
                          if (data.signature ==
                              user.matricule) // Uniqyement celui a remplit le document
                            sendButton(data),
                          if (data.approbationDG == "Unapproved" ||
                              data.approbationDD == "Unapproved")
                            deleteButton(data),
                          PrintWidget(
                              tooltip: 'Imprimer le document',
                              onPressed: () async {
                                await BilanPdf.generate(
                                    data, compteActifList, comptePassifList);
                              }),
                        ],
                      ),
                      Text(DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              totalMontant(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget totalMontant(BilanModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    return FutureBuilder<List<CompteBilanRefModel>>(
        future: dataFutureRef,
        builder: (BuildContext context,
            AsyncSnapshot<List<CompteBilanRefModel>> snapshot) {
          if (snapshot.hasData) {
            List<CompteBilanRefModel>? dataListActif = snapshot.data!
                .where((element) =>
                    element.reference == data.id && element.type == "Actif")
                .toList();
            List<CompteBilanRefModel>? dataListPassif = snapshot.data!
                .where((element) =>
                    element.reference == data.id && element.type == "Passif")
                .toList();

            double totalActif = 0.0;
            for (var item in dataListActif) {
              totalActif += double.parse(item.montant);
            }

            double totalPassif = 0.0;
            for (var item in dataListPassif) {
              totalPassif += double.parse(item.montant);
            }

            return Padding(
              padding: const EdgeInsets.all(p10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: Responsive.isMobile(context) ? 2 : 1,
                          child: Text('TOTAL :',
                              textAlign: TextAlign.start,
                              style: Responsive.isMobile(context)
                                  ? bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold)
                                  : headline6!
                                      .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: Responsive.isMobile(context) ? 2 : 3,
                          child: Text(
                              "${NumberFormat.decimalPattern('fr').format(totalActif)} \$",
                              textAlign: TextAlign.start,
                              style: headline6!
                                  .copyWith(color: Colors.red.shade700)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: p20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: Responsive.isMobile(context) ? 2 : 1,
                          child: Text('TOTAL :',
                              textAlign: TextAlign.start,
                              style: Responsive.isMobile(context)
                                  ? bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold)
                                  : headline6.copyWith(
                                      fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: Responsive.isMobile(context) ? 2 : 3,
                          child: Text(
                              "${NumberFormat.decimalPattern('fr').format(totalPassif)} \$",
                              textAlign: TextAlign.start,
                              style: headline6.copyWith(
                                  color: Colors.red.shade700)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: loading());
          }
        });
  }

  Widget deleteButton(BilanModel data) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.blue.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de faire cette action ?',
              style: TextStyle(color: mainColor)),
          content: (isLoadingDelete)
              ? loading()
              : const Text('Cette action permet de supprimer ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await BilanApi().deleteData(data.id!).then((value) {
                  setState(() {
                    isLoadingDelete = false;
                  });
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget sendButton(BilanModel data) {
    return IconButton(
      icon: Icon(Icons.send, color: Colors.green.shade700),
      tooltip: "Soumettre chez le directeur de departement",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous pour soumettre ce document ?',
              style: TextStyle(color: mainColor)),
          content: (isLoadingSend)
              ? loading()
              : const Text(
                  'Cette action permet de soumettre ce document chez le directeur de departement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                sendDD(data).then((value) {
                  setState(() {
                    isLoadingSend = false;
                  });
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(BilanModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text("Titre:",
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
              Expanded(flex: 3, child: Text(data.titleBilan, style: bodyMedium))
            ],
          ),
          const SizedBox(height: p20),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('ACTIF',
                        textAlign: TextAlign.start,
                        style: Responsive.isMobile(context)
                            ? bodyLarge!.copyWith(fontWeight: FontWeight.bold)
                            : headline6!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: p20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: Responsive.isMobile(context) ? 2 : 3,
                          child: Text("Comptes",
                              textAlign: TextAlign.start,
                              style: Responsive.isMobile(context)
                                  ? bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold)
                                  : bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: Responsive.isMobile(context) ? 2 : 1,
                          child: Text("Montant",
                              textAlign: TextAlign.center,
                              style: Responsive.isMobile(context)
                                  ? bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold)
                                  : bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: p30),
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: compteActifWidget(data))
                  ],
                ),
              ),
              Container(
                  color: mainColor,
                  width: 2,
                  height: MediaQuery.of(context).size.height / 1.5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(p8),
                  child: Column(
                    children: [
                      Text('PASSIF',
                          textAlign: TextAlign.start,
                          style: Responsive.isMobile(context)
                              ? bodyLarge!.copyWith(fontWeight: FontWeight.bold)
                              : headline6!
                                  .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: p20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: Responsive.isMobile(context) ? 2 : 3,
                            child: Text("Comptes",
                                textAlign: TextAlign.start,
                                style: Responsive.isMobile(context)
                                    ? bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: Responsive.isMobile(context) ? 2 : 1,
                            child: Text("Montant",
                                textAlign: TextAlign.center,
                                style: Responsive.isMobile(context)
                                    ? bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: p30),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: comptePassifWidget(data))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget compteActifWidget(BilanModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return FutureBuilder<List<CompteBilanRefModel>>(
        future: dataFutureRef,
        builder: (BuildContext context,
            AsyncSnapshot<List<CompteBilanRefModel>> snapshot) {
          if (snapshot.hasData) {
            List<CompteBilanRefModel>? dataList = snapshot.data!
                .where((element) =>
                    element.reference == data.id && element.type == "Actif")
                .toList();
            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final actif = dataList[index];
                var codeCompte = actif.comptes.split('_');
                var code = codeCompte.first;
                return Column(
                  children: [
                    Slidable(
                      enabled: (data.isSubmit == "true" ||
                              data.approbationDD == "Unapproved" ||
                              data.approbationDG == "Unapproved")
                          ? false
                          : true,
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                              flex: 2,
                              onPressed: (context) {
                                editLigneButton(actif);
                                setState(() {
                                  dataFutureRef = getDataFuture();
                                });
                              },
                              backgroundColor: Colors.purple.shade700,
                              foregroundColor: Colors.white,
                              icon: Icons.edit),
                          SlidableAction(
                            onPressed: (context) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                      'Etes-vous sûr de faire ceci ?'),
                                  content: (isLoadingSend)
                                      ? loading()
                                      : const Text(
                                          'Cette action permet de supprimer cette ligne.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Annuler'),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          await CompteBilanRefApi()
                                              .deleteData(actif.id)
                                              .then((value) {
                                            Navigator.pop(context);
                                            setState(() {
                                              isLoadingDeleteLigne = false;
                                            });
                                          });
                                          setState(() {
                                            dataFutureRef = getDataFuture();
                                          });
                                        },
                                        child: const Text('OK')),
                                  ],
                                ),
                              );
                            },
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: p10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: Responsive.isMobile(context) ? 2 : 3,
                              child: Text(
                                  Responsive.isMobile(context)
                                      ? code
                                      : actif.comptes,
                                  textAlign: TextAlign.start,
                                  style: bodyMedium),
                            ),
                            Expanded(
                              flex: Responsive.isMobile(context) ? 2 : 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                    color: mainColor,
                                    width: 2,
                                  ),
                                )),
                                child: Text(
                                    "${NumberFormat.decimalPattern('fr').format(double.parse(actif.montant))} \$",
                                    textAlign: TextAlign.center,
                                    style: bodyMedium),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: mainColor),
                  ],
                );
              },
            );
          } else {
            return Center(child: loading());
          }
        });
  }

  Widget comptePassifWidget(BilanModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    return FutureBuilder<List<CompteBilanRefModel>>(
        future: dataFutureRef,
        builder: (BuildContext context,
            AsyncSnapshot<List<CompteBilanRefModel>> snapshot) {
          if (snapshot.hasData) {
            List<CompteBilanRefModel>? dataList = snapshot.data!
                .where((element) =>
                    element.reference == data.id && element.type == "Passif")
                .toList();
            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final passif = dataList[index];
                var codeCompte = passif.comptes.split('_');
                var code = codeCompte.first;

                return Column(
                  children: [
                    Slidable(
                      enabled: (data.isSubmit == "true" ||
                              data.approbationDD == "Unapproved" ||
                              data.approbationDG == "Unapproved")
                          ? false
                          : true,
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            flex: 2,
                            onPressed: (context) {
                              editLigneButton(passif);
                              setState(() {
                                dataFutureRef = getDataFuture();
                              });
                            },
                            backgroundColor: Colors.purple.shade700,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            // label: 'Editer',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                      'Etes-vous sûr de faire ceci ?'),
                                  content: (isLoadingSend)
                                      ? loading()
                                      : const Text(
                                          'Cette action permet de supprimer cette ligne.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await CompteBilanRefApi()
                                            .deleteData(passif.id)
                                            .then((value) {
                                          Navigator.pop(context);
                                          setState(() {
                                            isLoadingDeleteLigne = false;
                                          });
                                        });
                                        setState(() {
                                          dataFutureRef = getDataFuture();
                                        });
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            // label: 'Delete',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: p10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: Responsive.isMobile(context) ? 2 : 3,
                              child: Text(
                                  Responsive.isMobile(context)
                                      ? code
                                      : passif.comptes,
                                  textAlign: TextAlign.start,
                                  style: bodyMedium),
                            ),
                            Expanded(
                              flex: Responsive.isMobile(context) ? 2 : 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                    color: mainColor,
                                    width: 2,
                                  ),
                                )),
                                child: Text(
                                    "${NumberFormat.decimalPattern('fr').format(double.parse(passif.montant))} \$",
                                    textAlign: TextAlign.center,
                                    style: bodyMedium),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: mainColor,
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: loading());
          }
        });
  }

  editLigneButton(CompteBilanRefModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          final formEditKey = GlobalKey<FormState>();
          bool isLoading = false;
          String? comptesAllSelect;

          List<String> comptesList = [];
          final comptesDropdown = ComptesDropdown().classCompte;
          final class1Dropdown = ComptesDropdown().classe1compte;
          final class2Dropdown = ComptesDropdown().classe2compte;
          final class3Dropdown = ComptesDropdown().classe3compte;
          final class4Dropdown = ComptesDropdown().classe4compte;
          final class5Dropdown = ComptesDropdown().classe5compte;
          final class6Dropdown = ComptesDropdown().classe6compte;
          final class7Dropdown = ComptesDropdown().classe7compte;
          final class8Dropdown = ComptesDropdown().classe8compte;
          final class9Dropdown = ComptesDropdown().classe9compte;

          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text(data.comptes, style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: Responsive.isMobile(context) ? 350 : 300,
                  width: Responsive.isMobile(context) ? 300 : 400,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: formEditKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Responsive.isMobile(context)
                                  ? Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Classe des comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptesAllSelect,
                                            isExpanded: true,
                                            items: comptesDropdown
                                                .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                })
                                                .toSet()
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                comptesAllSelect = value;
                                                comptesList.clear();
                                                switch (comptesAllSelect) {
                                                  case "Classe_1_Comptes_de_ressources_durables":
                                                    comptesList
                                                        .addAll(class1Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_2_Comptes_Actif_immobilise":
                                                    comptesList
                                                        .addAll(class2Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_3_Comptes_de_stocks":
                                                    comptesList
                                                        .addAll(class3Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_4_Comptes_de_tiers":
                                                    comptesList
                                                        .addAll(class4Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_5_Comptes_de_tresorerie":
                                                    comptesList
                                                        .addAll(class5Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_6_Comptes_de_charges_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class6Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_7_Comptes_de_produits_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class7Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_8_Comptes_des_autres_charges_et_des_autres_produits":
                                                    comptesList
                                                        .addAll(class8Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion":
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  default:
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptes,
                                            isExpanded: true,
                                            items: comptesList
                                                .map((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value!),
                                              );
                                            }).toList(),
                                            validator: (value) => value == null
                                                ? "Select compte"
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                comptes = value!;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Classe des comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptesAllSelect,
                                            isExpanded: true,
                                            items: comptesDropdown
                                                .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                })
                                                .toSet()
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                comptesAllSelect = value;
                                                comptesList.clear();
                                                switch (comptesAllSelect) {
                                                  case "Classe_1_Comptes_de_ressources_durables":
                                                    comptesList
                                                        .addAll(class1Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_2_Comptes_Actif_immobilise":
                                                    comptesList
                                                        .addAll(class2Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_3_Comptes_de_stocks":
                                                    comptesList
                                                        .addAll(class3Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_4_Comptes_de_tiers":
                                                    comptesList
                                                        .addAll(class4Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_5_Comptes_de_tresorerie":
                                                    comptesList
                                                        .addAll(class5Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_6_Comptes_de_charges_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class6Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_7_Comptes_de_produits_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class7Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_8_Comptes_des_autres_charges_et_des_autres_produits":
                                                    comptesList
                                                        .addAll(class8Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion":
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  default:
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                }
                                              });
                                            },
                                          ),
                                        )),
                                        const SizedBox(width: p10),
                                        Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptes,
                                            isExpanded: true,
                                            items: comptesList
                                                .map((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value!),
                                              );
                                            }).toList(),
                                            validator: (value) => value == null
                                                ? "Select compte"
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                comptes = value!;
                                              });
                                            },
                                          ),
                                        )),
                                      ],
                                    ),
                              typeWidget(),
                              montant(),
                            ],
                          ))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    isLoading = true;
                    final form = formEditKey.currentState!;
                    if (form.validate()) {
                      submitEdit(data).then((value) => isLoading = false);
                      form.reset();
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Future<void> sendDD(BilanModel data) async {
    final bilanModel = BilanModel(
        id: data.id,
        titleBilan: data.titleBilan,
        signature: data.signature,
        created: data.created,
        isSubmit: 'true',
        approbationDG: 'Approved',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: 'Approved',
        motifDD: '-',
        signatureDD: '-');
    await BilanApi().updateData(bilanModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Envoie effectué avec succès!"),
        backgroundColor: Colors.blue[700],
      ));
    });
  }

  newEcritureDialog(BilanModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          final formKey = GlobalKey<FormState>();
          bool isLoading = false;
          String? comptesAllSelect;

          List<String> comptesList = [];
          final comptesDropdown = ComptesDropdown().classCompte;
          final class1Dropdown = ComptesDropdown().classe1compte;
          final class2Dropdown = ComptesDropdown().classe2compte;
          final class3Dropdown = ComptesDropdown().classe3compte;
          final class4Dropdown = ComptesDropdown().classe4compte;
          final class5Dropdown = ComptesDropdown().classe5compte;
          final class6Dropdown = ComptesDropdown().classe6compte;
          final class7Dropdown = ComptesDropdown().classe7compte;
          final class8Dropdown = ComptesDropdown().classe8compte;
          final class9Dropdown = ComptesDropdown().classe9compte;

          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('New document', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: Responsive.isMobile(context) ? 350 : 300,
                  width: Responsive.isMobile(context) ? 300 : 400,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Responsive.isMobile(context)
                                  ? Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Classe des comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptesAllSelect,
                                            isExpanded: true,
                                            items: comptesDropdown
                                                .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                })
                                                .toSet()
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                comptesAllSelect = value;
                                                comptesList.clear();
                                                switch (comptesAllSelect) {
                                                  case "Classe_1_Comptes_de_ressources_durables":
                                                    comptesList
                                                        .addAll(class1Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_2_Comptes_Actif_immobilise":
                                                    comptesList
                                                        .addAll(class2Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_3_Comptes_de_stocks":
                                                    comptesList
                                                        .addAll(class3Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_4_Comptes_de_tiers":
                                                    comptesList
                                                        .addAll(class4Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_5_Comptes_de_tresorerie":
                                                    comptesList
                                                        .addAll(class5Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_6_Comptes_de_charges_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class6Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_7_Comptes_de_produits_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class7Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_8_Comptes_des_autres_charges_et_des_autres_produits":
                                                    comptesList
                                                        .addAll(class8Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion":
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  default:
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptes,
                                            isExpanded: true,
                                            items: comptesList
                                                .map((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value!),
                                              );
                                            }).toList(),
                                            validator: (value) => value == null
                                                ? "Select compte"
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                comptes = value!;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Classe des comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptesAllSelect,
                                            isExpanded: true,
                                            items: comptesDropdown
                                                .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                })
                                                .toSet()
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                comptesAllSelect = value;
                                                comptesList.clear();
                                                switch (comptesAllSelect) {
                                                  case "Classe_1_Comptes_de_ressources_durables":
                                                    comptesList
                                                        .addAll(class1Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_2_Comptes_Actif_immobilise":
                                                    comptesList
                                                        .addAll(class2Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_3_Comptes_de_stocks":
                                                    comptesList
                                                        .addAll(class3Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_4_Comptes_de_tiers":
                                                    comptesList
                                                        .addAll(class4Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_5_Comptes_de_tresorerie":
                                                    comptesList
                                                        .addAll(class5Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_6_Comptes_de_charges_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class6Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_7_Comptes_de_produits_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class7Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_8_Comptes_des_autres_charges_et_des_autres_produits":
                                                    comptesList
                                                        .addAll(class8Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion":
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  default:
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                }
                                              });
                                            },
                                          ),
                                        )),
                                        const SizedBox(width: p10),
                                        Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptes,
                                            isExpanded: true,
                                            items: comptesList
                                                .map((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value!),
                                              );
                                            }).toList(),
                                            validator: (value) => value == null
                                                ? "Select compte"
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                comptes = value!;
                                              });
                                            },
                                          ),
                                        )),
                                      ],
                                    ),
                              typeWidget(),
                              montant(),
                            ],
                          ))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    isLoading = true;
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      submit(data).then((value) => isLoading = false);
                      form.reset();
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget typeWidget() {
    List<String> typeList = ["Actif", "Passif"];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: type,
        isExpanded: true,
        items: typeList.map((String? value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value!),
          );
        }).toList(),
        validator: (value) => value == null ? "Select type" : null,
        onChanged: (value) {
          setState(() {
            type = value!;
          });
        },
      ),
    );
  }

  Widget montant() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant \$',
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

  Future<void> submit(BilanModel data) async {
    final compteBilanRefModel = CompteBilanRefModel(
        id: 0,
        reference: data.id!,
        comptes: comptes.toString(),
        montant: (montantController.text == "") ? "0" : montantController.text,
        type: type.toString());
    await CompteBilanRefApi().insertData(compteBilanRefModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitEdit(CompteBilanRefModel bilanRef) async {
    final compteBilanRefModel = CompteBilanRefModel(
        id: bilanRef.id,
        reference: bilanRef.reference,
        comptes:
            (comptes.toString() == "") ? bilanRef.comptes : comptes.toString(),
        montant: (montantController.text == "")
            ? bilanRef.montant
            : montantController.text,
        type: (type.toString() == "") ? bilanRef.type : type.toString());
    await CompteBilanRefApi().updateData(compteBilanRefModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Mise à jour avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
