import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/trans_rest_agents_api.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/components/transport_rest_pdf.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailTransRestDesktop extends StatefulWidget {
  const DetailTransRestDesktop(
      {Key? key,
      required this.transportRestaurationModel,
      required this.departementsList,
      required this.ligneBudgetaireList,
      required this.user,
      required this.transRestAgentsList})
      : super(key: key);

  final TransportRestaurationModel transportRestaurationModel;
  final List<DepartementBudgetModel> departementsList;
  final List<LigneBudgetaireModel> ligneBudgetaireList;
  final UserModel user;
  final List<TransRestAgentsModel> transRestAgentsList;

  @override
  State<DetailTransRestDesktop> createState() => _DetailTransRestDesktopState();
}

class _DetailTransRestDesktopState extends State<DetailTransRestDesktop> {
  final _formKeyBudget = GlobalKey<FormState>();
  final ScrollController controllerTable = ScrollController();

  bool isLoading = false;
  bool isChecked = false;
  bool isDeleting = false;

  // Approbations
  String approbationDG = '-';
  String approbationBudget = '-';
  String approbationFin = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifBudgetController = TextEditingController();
  TextEditingController motifFinController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();
  String? ligneBudgtaire;
  String? ressource;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        pageDetail(widget.transportRestaurationModel),
        const SizedBox(height: p10),
        approbationWidget(widget.transportRestaurationModel)
      ],
    ));
  }

  Widget pageDetail(TransportRestaurationModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: MediaQuery.of(context).size.width / 2,
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
                  if (Responsive.isDesktop(context))
                    TitleWidget(title: data.title),
                  if (!Responsive.isDesktop(context)) Container(),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              color: Colors.green.shade700,
                              onPressed: () {
                                sendDD(data);
                              },
                              icon: const Icon(Icons.send)),
                          PrintWidget(onPressed: () async {
                            await TransRestPdf.generate(
                                widget.transRestAgentsList, data);
                          }),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              tableListAgents(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(TransportRestaurationModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Intitlé :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.title,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Observation :',
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: p10,
              ),
              if (data.observation == 'false' &&
                  widget.user.departement == "Finances")
                Expanded(flex: 3, child: checkboxRead(data)),
              Expanded(
                  flex: 3,
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
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
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

  checkboxRead(TransportRestaurationModel data) {
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
            submitObservation(data);
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Confirmation de Paiement"),
    );
  }

  Widget tableListAgents(TransportRestaurationModel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(1),
        },
        children: [
          tableRowHeader(),
          for (var item in widget.transRestAgentsList) tableRow(item, data)
        ],
      ),
    );
  }

  TableRow tableRowHeader() {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: const AutoSizeText("Nom"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: const AutoSizeText("Prenom"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: const AutoSizeText("Matricule"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: const AutoSizeText("Montant"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: const AutoSizeText("Retirer"),
      ),
    ]);
  }

  TableRow tableRow(
      TransRestAgentsModel item, TransportRestaurationModel data) {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: AutoSizeText(item.nom),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: AutoSizeText(item.prenom),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: AutoSizeText(item.matricule),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(item.montant))} \$"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        width: 200,
        child: (data.approbationDD == "Approved")
            ? Icon(Icons.check_box, color: Colors.green.shade700)
            : IconButton(
                color: Colors.red.shade700,
                onPressed: () async {
                  setState(() {
                    isDeleting = true;
                  });
                  await TransRestAgentsApi().deleteData(item.id!);
                },
                icon: const Icon(Icons.delete)),
      ),
    ]);
  }

  Future<void> sendDD(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
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
        ressource: data.ressource,
        isSubmit: 'true');
    await TransportRestaurationApi().updateData(transRest).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitObservation(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
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
        ressource: data.ressource,
        isSubmit: data.isSubmit);
    await TransportRestaurationApi().updateData(transRest).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Widget approbationWidget(TransportRestaurationModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        color: Colors.red[50],
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.red.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TitleWidget(title: "Approbations"),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_task, color: Colors.green.shade700)),
                ],
              ),
              const SizedBox(height: p20),
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("Directeur générale", style: bodyLarge)),
                    const SizedBox(width: p20),
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Approbation"),
                                      const SizedBox(height: p20),
                                      Text(data.approbationDG,
                                          style: bodyLarge!.copyWith(
                                              color: (data.approbationDG ==
                                                      "Unapproved")
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700)),
                                    ],
                                  )),
                              if (data.approbationDG == "Unapproved")
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        const Text("Motif"),
                                        const SizedBox(height: p20),
                                        Text(data.motifDG),
                                      ],
                                    )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Signature"),
                                      const SizedBox(height: p20),
                                      Text(data.signatureDG),
                                    ],
                                  )),
                            ]),
                            if (data.approbationDG == '-' &&
                                widget.user.fonctionOccupe ==
                                    "Directeur générale")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(children: [
                                  Expanded(child: approbationDGWidget(data)),
                                  const SizedBox(width: p20),
                                  if (approbationDG == "Unapproved")
                                    Expanded(child: motifDGWidget(data))
                                ]),
                              ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: p20),
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                            Text("Directeur de departement", style: bodyLarge)),
                    const SizedBox(width: p20),
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Approbation"),
                                      const SizedBox(height: p20),
                                      Text(data.approbationDD,
                                          style: bodyLarge.copyWith(
                                              color: (data.approbationDD ==
                                                      "Unapproved")
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700)),
                                    ],
                                  )),
                              if (data.approbationDD == "Unapproved")
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        const Text("Motif"),
                                        const SizedBox(height: p20),
                                        Text(data.motifDD),
                                      ],
                                    )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Signature"),
                                      const SizedBox(height: p20),
                                      Text(data.signatureDD),
                                    ],
                                  )),
                            ]),
                            if (data.approbationDD == '-' &&
                                widget.user.fonctionOccupe ==
                                    "Directeur de departement")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(children: [
                                  Expanded(child: approbationDDWidget(data)),
                                  const SizedBox(width: p20),
                                  if (approbationDD == "Unapproved")
                                    Expanded(child: motifDDWidget(data))
                                ]),
                              ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: p20),
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text("Budget", style: bodyLarge)),
                    const SizedBox(width: p20),
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Approbation"),
                                      const SizedBox(height: p20),
                                      Text(data.approbationBudget,
                                          style: bodyLarge.copyWith(
                                              color: (data.approbationBudget ==
                                                      "Unapproved")
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700)),
                                    ],
                                  )),
                              if (data.approbationBudget == "Unapproved")
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        const Text("Motif"),
                                        const SizedBox(height: p20),
                                        Text(data.motifBudget),
                                      ],
                                    )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Signature"),
                                      const SizedBox(height: p20),
                                      Text(data.signatureBudget),
                                    ],
                                  )),
                            ]),
                            const SizedBox(height: p20),
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Ligne Budgetaire"),
                                      const SizedBox(height: p20),
                                      Text(data.ligneBudgetaire,
                                          style: bodyLarge.copyWith(
                                              color: Colors.purple.shade700)),
                                    ],
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Ressource"),
                                      const SizedBox(height: p20),
                                      Text(data.ressource,
                                          style: bodyLarge.copyWith(
                                              color: Colors.purple.shade700)),
                                    ],
                                  )),
                            ]),
                            if (data.approbationBudget == '-' &&
                                widget.user.fonctionOccupe ==
                                    "Directeur de budget")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Form(
                                  key: _formKeyBudget,
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        Expanded(child: ligneBudgtaireWidget()),
                                        const SizedBox(width: p20),
                                        Expanded(child: resourcesWidget())
                                      ]),
                                      Row(children: [
                                        Expanded(
                                            child:
                                                approbationBudgetWidget(data)),
                                        const SizedBox(width: p20),
                                        if (approbationBudget == "Unapproved")
                                          Expanded(
                                              child: motifBudgetWidget(data))
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: p20),
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text("Finance", style: bodyLarge)),
                    const SizedBox(width: p20),
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Approbation"),
                                      const SizedBox(height: p20),
                                      Text(data.approbationFin,
                                          style: bodyLarge.copyWith(
                                              color: (data.approbationFin ==
                                                      "Unapproved")
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700)),
                                    ],
                                  )),
                              if (data.approbationFin == "Unapproved")
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        const Text("Motif"),
                                        const SizedBox(height: p20),
                                        Text(data.motifFin),
                                      ],
                                    )),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text("Signature"),
                                      const SizedBox(height: p20),
                                      Text(data.signatureFin),
                                    ],
                                  )),
                            ]),
                            if (data.approbationFin == '-' &&
                                widget.user.fonctionOccupe ==
                                    "Directeur de finance")
                              Padding(
                                padding: const EdgeInsets.all(p10),
                                child: Row(children: [
                                  Expanded(child: approbationFinWidget(data)),
                                  const SizedBox(width: p20),
                                  if (approbationFin == "Unapproved")
                                    Expanded(child: motifFinWidget(data))
                                ]),
                              ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDGWidget(TransportRestaurationModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationDG,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationDG = value!;
            if (approbationDG == "Approved") {
              submitDG(data);
            }
          });
        },
      ),
    );
  }

  Widget motifDGWidget(TransportRestaurationModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDGController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitDG(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Widget approbationDDWidget(TransportRestaurationModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationDD,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationDD = value!;
            if (approbationDD == "Approved") {
              submitDD(data);
            }
          });
        },
      ),
    );
  }

  Widget motifDDWidget(TransportRestaurationModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifDDController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitDD(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Widget approbationBudgetWidget(TransportRestaurationModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationBudget,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationBudget = value!;
            final form = _formKeyBudget.currentState!;
            if (form.validate()) {
              if (approbationBudget == "Approved") {
                submitBudget(data);
              }
            }
          });
        },
      ),
    );
  }

  Widget motifBudgetWidget(TransportRestaurationModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifBudgetController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitBudget(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  Widget approbationFinWidget(TransportRestaurationModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Approbation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: approbationFin,
        isExpanded: true,
        items: approbationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            approbationFin = value!;
            if (approbationFin == "Approved") {
              submitFin(data);
            }
          });
        },
      ),
    );
  }

  Widget motifFinWidget(TransportRestaurationModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: motifFinController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ecrivez le motif...',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: 'Soumettre le Motif',
                  onPressed: () {
                    submitFin(data);
                  },
                  icon: Icon(Icons.send, color: Colors.red.shade700)),
            )
          ],
        ));
  }

  // Soumettre une ligne budgetaire
  Widget ligneBudgtaireWidget() {
    List<String> dataList = [];
    for (var i in widget.departementsList) {
      dataList = widget.ligneBudgetaireList
          .where((element) =>
              element.periodeBudgetDebut.microsecondsSinceEpoch ==
                  i.periodeDebut.microsecondsSinceEpoch &&
              i.approbationDG == "Approved" &&
              i.approbationDD == "Approved" &&
              DateTime.now().isBefore(element.periodeBudgetFin) &&
              element.departement == "Ressources Humaines")
          .map((e) => e.nomLigneBudgetaire)
          .toList();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ligne Budgetaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: ligneBudgtaire,
        isExpanded: true,
        items: dataList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select Ligne Budgetaire" : null,
        onChanged: (value) {
          setState(() {
            ligneBudgtaire = value!;
          });
        },
      ),
    );
  }

  Widget resourcesWidget() {
    List<String> dataList = ['caisse', 'banque', 'finExterieur'];
    return Container(
      margin: const EdgeInsets.only(bottom: p10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Resource',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: ressource,
        isExpanded: true,
        items: dataList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select Resource" : null,
        onChanged: (value) {
          setState(() {
            ressource = value!;
          });
        },
      ),
    );
  }

  Future<void> submitDG(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        approbationDG: approbationDG,
        motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
        signatureDG: widget.user.matricule,
        approbationBudget: '-',
        motifBudget: '-',
        signatureBudget: '-',
        approbationFin: '-',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire: '-',
        ressource: '-',
        isSubmit: data.isSubmit);
    await TransportRestaurationApi().updateData(transRest).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitDD(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationBudget: '-',
        motifBudget: '-',
        signatureBudget: '-',
        approbationFin: '-',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: widget.user.matricule,
        ligneBudgetaire: '-',
        ressource: '-',
        isSubmit: data.isSubmit);
    await TransportRestaurationApi().updateData(transRest).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitBudget(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        approbationDG: data.approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationBudget: approbationBudget,
        motifBudget: (motifBudgetController.text == '')
            ? '-'
            : motifBudgetController.text,
        signatureBudget: widget.user.matricule,
        approbationFin: '-',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire:
            (ligneBudgtaire.toString() == '') ? '-' : ligneBudgtaire.toString(),
        ressource: (ressource.toString() == '') ? '-' : ressource.toString(),
        isSubmit: data.isSubmit);
    await TransportRestaurationApi().updateData(transRest).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitFin(TransportRestaurationModel data) async {
    final transRest = TransportRestaurationModel(
        id: data.id!,
        title: data.title,
        observation: data.observation,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        approbationDG: data.approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationBudget: data.approbationBudget,
        motifBudget: data.motifBudget,
        signatureBudget: data.signatureBudget,
        approbationFin: approbationFin,
        motifFin:
            (motifFinController.text == '') ? '-' : motifFinController.text,
        signatureFin: widget.user.matricule,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire: data.ligneBudgetaire,
        ressource: data.ressource,
        isSubmit: data.isSubmit);
    await TransportRestaurationApi().updateData(transRest).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
