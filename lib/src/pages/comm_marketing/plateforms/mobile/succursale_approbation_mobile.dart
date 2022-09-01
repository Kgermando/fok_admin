import 'dart:async';

import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class SuccursaleApprobationMobile extends StatefulWidget {
  const SuccursaleApprobationMobile(
      {Key? key, required this.user, required this.succursaleModel})
      : super(key: key);

  final UserModel user;
  final SuccursaleModel succursaleModel;

  @override
  State<SuccursaleApprobationMobile> createState() =>
      _SuccursaleApprobationMobileState();
}

class _SuccursaleApprobationMobileState
    extends State<SuccursaleApprobationMobile> {
  final ScrollController controllerTable = ScrollController();

  bool isLoading = false;
  bool isChecked = false;
  bool isDeleting = false;

  // Approbations
  String approbationDG = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();
  String? ligneBudgtaire;
  String? ressource;

  @override
  Widget build(BuildContext context) {
    return approbationWidget(widget.succursaleModel);
  }

  Widget approbationWidget(SuccursaleModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        color: Colors.red[50],
        child: Container(
          margin: const EdgeInsets.all(p10),
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
                child: Column(
                  children: [
                    Text("Directeur générale",
                        style:
                            bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: p20),
                    Row(
                      children: [
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
                                              style: bodyLarge.copyWith(
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
                                    child: Column(children: [
                                      approbationDGWidget(data),
                                      const SizedBox(width: p20),
                                      if (approbationDG == "Unapproved")
                                        motifDGWidget(data)
                                    ]),
                                  ),
                              ],
                            )),
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
                        style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: p20),
                    Row(
                      children: [
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
                                              style: bodyLarge.copyWith(
                                                  color: (data.approbationDG ==
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
                                    child: Column(children: [
                                      approbationDDWidget(data),
                                      const SizedBox(width: p20),
                                      if (approbationDD == "Unapproved")
                                        motifDDWidget(data)
                                    ]),
                                  ),
                              ],
                            )),
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

  Widget approbationDGWidget(SuccursaleModel data) {
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

  Widget motifDGWidget(SuccursaleModel data) {
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

  Widget approbationDDWidget(SuccursaleModel data) {
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

  Widget motifDDWidget(SuccursaleModel data) {
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

  Future<void> submitDG(SuccursaleModel data) async {
    final succursale = SuccursaleModel(
        id: data.id!,
        name: data.name,
        adresse: data.adresse,
        province: data.province,
        signature: data.signature,
        created: data.created,
        approbationDG: approbationDG,
        motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
        signatureDG: widget.user.matricule,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD);
    await SuccursaleApi().updateData(succursale).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitDD(SuccursaleModel data) async {
    final succursale = SuccursaleModel(
        id: data.id!,
        name: data.name,
        adresse: data.adresse,
        province: data.province,
        signature: data.signature,
        created: data.created,
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: widget.user.matricule);
    await SuccursaleApi().updateData(succursale).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
