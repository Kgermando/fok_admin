import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/components/table_agent_projet.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailCampaign extends StatefulWidget {
  const DetailCampaign({Key? key}) : super(key: key);

  @override
  State<DetailCampaign> createState() => _DetailCampaignState();
}

class _DetailCampaignState extends State<DetailCampaign> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  bool isChecked = false;
  bool isLoadingDelete = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  List<DepartementBudgetModel> departementsList = [];
  List<LigneBudgetaireModel> ligneBudgetaireList = [];
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
    var departements = await DepeartementBudgetApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    setState(() {
      user = userModel;
      departementsList = departements;
      ligneBudgetaireList = budgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
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
                    child: FutureBuilder<CampaignModel>(
                        future: CampaignApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<CampaignModel> snapshot) {
                          if (snapshot.hasData) {
                            CampaignModel? data = snapshot.data;
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
                                      flex: 5,
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
                                      pageDetail(data!),
                                      const SizedBox(height: p10),
                                      // LayoutBuilder(
                                      //     builder: (context, constraints) {
                                      //   if (constraints.maxWidth >= 1100) {
                                      //     return CampagneApprobationDesktop(
                                      //         departementsList:
                                      //             departementsList,
                                      //         ligneBudgetaireList:
                                      //             ligneBudgetaireList,
                                      //         user: user,
                                      //         campaignModel: data);
                                      //   } else if (constraints.maxWidth <
                                      //           1100 &&
                                      //       constraints.maxWidth >= 650) {
                                      //     return CampagneApprobationTablet(
                                      //         departementsList:
                                      //             departementsList,
                                      //         ligneBudgetaireList:
                                      //             ligneBudgetaireList,
                                      //         user: user,
                                      //         campaignModel: data);
                                      //   } else {
                                      //     return CampagneApprobationMobile(
                                      //         departementsList:
                                      //             departementsList,
                                      //         ligneBudgetaireList:
                                      //             ligneBudgetaireList,
                                      //         user: user,
                                      //         campaignModel: data);
                                      //   }
                                      // })
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

  Widget pageDetail(CampaignModel data) {
    int userRole = int.parse(user.role);
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
              color: mainColor,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.typeProduit),
                  Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              if (userRole <= 3)
                                IconButton(
                                    tooltip: "Modification du document",
                                    color: Colors.purple,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context,
                                          ComMarketingRoutes
                                              .comMarketingCampaignUpdate,
                                          arguments: data);
                                    },
                                    icon: const Icon(Icons.edit)),
                              if (userRole <= 3 && data.approbationDD == "-")
                                deleteButton(data),
                            ],
                          ),
                          SelectableText(
                              DateFormat("dd-MM-yyyy HH:mm")
                                  .format(data.created),
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              SizedBox(
                  height: 500,
                  child: ListAgentProjet(
                      createdRef: data.createdRef,
                      approuved: data.approbationDD)),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget deleteButton(CampaignModel data) {
    return IconButton(
      color: Colors.red.shade700,
      icon: const Icon(Icons.delete),
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?'),
          content:
              const Text('Cette action permet de supprimer définitivement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoadingDelete = true;
                });
                await CampaignApi().deleteData(data.id!).then((value) {
                  setState(() {
                    isLoadingDelete = false;
                  });
                  Navigator.pop(context, 'true');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("${data.typeProduit} vient d'être supprimé!"),
                    backgroundColor: Colors.red[700],
                  ));
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(CampaignModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          const SizedBox(
            height: p20,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Produit :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.typeProduit,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text('Produit :',
                          textAlign: TextAlign.start,
                          style: bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: SelectableText(data.typeProduit,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Date Debut Et Fin :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.dateDebutEtFin,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text('Date Debut Et Fin :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: SelectableText(data.dateDebutEtFin,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Coût de la Campagne :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(data.coutCampaign))} \$",
                        textAlign: TextAlign.start,
                        style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text('Coût de la Campagne :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: SelectableText(
                          "${NumberFormat.decimalPattern('fr').format(double.parse(data.coutCampaign))} \$",
                          textAlign: TextAlign.start,
                          style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Lieu Cible :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.lieuCible,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text('Lieu Cible :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: SelectableText(data.lieuCible,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Objet de la Promotion :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.promotion,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text('Objet de la Promotion :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: SelectableText(data.promotion,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Objectifs :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.objectifs,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text('Objectifs :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: SelectableText(data.objectifs,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text(
                      'Observation',
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (data.observation == 'false' &&
                        user.departement == "Finances")
                      checkboxRead(data),
                    (data.observation == 'true')
                        ? SelectableText(
                            'Payé',
                            style: bodyMedium.copyWith(
                                color: Colors.greenAccent.shade700),
                          )
                        : SelectableText(
                            'Non payé',
                            style: bodyMedium.copyWith(
                                color: Colors.redAccent.shade700),
                          )
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Observation',
                        style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: p10,
                    ),
                    if (data.observation == 'false' &&
                        user.departement == "Finances")
                      Expanded(child: checkboxRead(data)),
                    Expanded(
                        child: (data.observation == 'true')
                            ? SelectableText(
                                'Payé',
                                style: bodyMedium.copyWith(
                                    color: Colors.greenAccent.shade700),
                              )
                            : SelectableText(
                                'Non payé',
                                style: bodyMedium.copyWith(
                                    color: Colors.redAccent.shade700),
                              ))
                  ],
                ),
          Divider(color: mainColor),
        ],
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead(CampaignModel data) {
    isChecked = data.observation == 'true';
    return ListTile(
      leading: Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isLoading = true;
          });
          setState(() {
            isChecked = value!;
            submitobservation(data);
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Confirmation de payement"),
    );
  }

  Future<void> submitobservation(CampaignModel data) async {
    final campaignModel = CampaignModel(
        id: data.id!,
        typeProduit: data.typeProduit,
        dateDebutEtFin: data.dateDebutEtFin,
        coutCampaign: data.coutCampaign,
        lieuCible: data.lieuCible,
        promotion: data.promotion,
        objectifs: data.objectifs,
        observation: 'true',
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        approbationDG: data.approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationBudget: data.approbationBudget,
        motifBudget: data.motifBudget,
        signatureBudget: data.signatureBudget,
        approbationFin: data.approbationFin,
        motifFin: data.motifFin,
        signatureFin: data.signatureFin,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire: data.ligneBudgetaire,
        ressource: data.ressource);
    await CampaignApi().updateData(campaignModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Paiement effectuée avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
