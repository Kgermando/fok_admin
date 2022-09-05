import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class BudgetApprobationMobile extends StatefulWidget {
  const BudgetApprobationMobile(
      {Key? key, required this.departementBudgetModel, required this.user})
      : super(key: key);
  final DepartementBudgetModel departementBudgetModel;
  final UserModel user;

  @override
  State<BudgetApprobationMobile> createState() =>
      _BudgetApprobationMobileState();
}

class _BudgetApprobationMobileState extends State<BudgetApprobationMobile> {
  // Approbations
  String approbationDG = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();

  @override
  void dispose() {
    motifDGController.dispose();
    motifDDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return approbationWidget(widget.departementBudgetModel);
  }

  Widget approbationWidget(DepartementBudgetModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        color: Colors.red[50],
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: MediaQuery.of(context).size.width / 1.2,
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
                  const TitleWidget(title: 'Approbations'),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_task, color: Colors.green.shade700)),
                ],
              ),
              const SizedBox(height: p20),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Column(
                  children: [
                    Text("Directeur générale",
                        style:
                            bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: p20),
                    Column(
                      children: [
                        Column(
                          children: [
                            const Text("Approbation"),
                            const SizedBox(height: p20),
                            Text(data.approbationDG,
                                style: bodyLarge.copyWith(
                                    color: (data.approbationDG == "Unapproved")
                                        ? Colors.red.shade700
                                        : Colors.green.shade700)),
                          ],
                        ),
                        if (data.approbationDG == "Unapproved")
                          Column(
                            children: [
                              const Text("Motif"),
                              const SizedBox(height: p20),
                              Text(data.motifDG),
                            ],
                          ),
                        Column(
                          children: [
                            const Text("Signature"),
                            const SizedBox(height: p20),
                            Text(data.signatureDG),
                          ],
                        ),
                        if (data.approbationDG == '-' &&
                            widget.user.fonctionOccupe == "Directeur générale")
                          Padding(
                            padding: const EdgeInsets.all(p10),
                            child: Column(children: [
                              approbationDGWidget(data),
                              const SizedBox(width: p20),
                              if (approbationDG == "Unapproved")
                                motifDGWidget(data)
                            ]),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: p20),
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Column(
                  children: [
                    Text("Directeur de departement",
                        textAlign: TextAlign.left,
                        style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: p20),
                    Column(
                      children: [
                        const Text("Approbation"),
                        const SizedBox(height: p20),
                        Text(data.approbationDD,
                            style: bodyLarge.copyWith(
                                color: (data.approbationDD == "Unapproved")
                                    ? Colors.red.shade700
                                    : Colors.green.shade700)),
                        if (data.approbationDD == "Unapproved")
                          Column(
                            children: [
                              const Text("Motif"),
                              const SizedBox(height: p20),
                              Text(data.motifDD),
                            ],
                          ),
                        Column(
                          children: [
                            const Text("Signature"),
                            const SizedBox(height: p20),
                            Text(data.signatureDD),
                          ],
                        ),
                        if (data.approbationDD == '-' &&
                            widget.user.fonctionOccupe ==
                                "Directeur de budget") // ON est dans le dep du budget
                          Padding(
                            padding: const EdgeInsets.all(p10),
                            child: Column(children: [
                              approbationDDWidget(data),
                              const SizedBox(width: p20),
                              if (approbationDD == "Unapproved")
                                motifDDWidget(data)
                            ]),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget approbationDGWidget(DepartementBudgetModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
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

  Widget motifDGWidget(DepartementBudgetModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
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

  Widget approbationDDWidget(DepartementBudgetModel data) {
    List<String> approbationList = ['Approved', 'Unapproved', '-'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
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

  Widget motifDDWidget(DepartementBudgetModel data) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
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

  Future<void> submitDG(DepartementBudgetModel data) async {
    final departementBudgetModel = DepartementBudgetModel(
        id: data.id!,
        title: data.title,
        departement: data.departement,
        periodeDebut: data.periodeDebut,
        periodeFin: data.periodeFin,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        isSubmit: data.isSubmit,
        approbationDG: approbationDG,
        motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
        signatureDG: widget.user.matricule,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD);
    await DepeartementBudgetApi()
        .updateData(departementBudgetModel)
        .then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitDD(DepartementBudgetModel data) async {
    final departementBudgetModel = DepartementBudgetModel(
        id: data.id!,
        title: data.title,
        departement: data.departement,
        periodeDebut: data.periodeDebut,
        periodeFin: data.periodeFin,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        isSubmit: data.isSubmit,
        approbationDG: 'Approved',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: widget.user.matricule);
    await DepeartementBudgetApi()
        .updateData(departementBudgetModel)
        .then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
