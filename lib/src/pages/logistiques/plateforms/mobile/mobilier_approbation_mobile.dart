import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class MobilierApprobationMobile extends StatefulWidget {
  const MobilierApprobationMobile(
      {Key? key, required this.mobilierModel, required this.user})
      : super(key: key);
  final MobilierModel mobilierModel;
  final UserModel user;

  @override
  State<MobilierApprobationMobile> createState() =>
      _MobilierApprobationMobileState();
}

class _MobilierApprobationMobileState extends State<MobilierApprobationMobile> {
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
    return approbationWidget(widget.mobilierModel);
  }

  Widget approbationWidget(MobilierModel data) {
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
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Column(
                  children: [
                    Text("Directeur de departement",
                        textAlign: TextAlign.left,
                        style:
                            bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
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

  Widget approbationDDWidget(MobilierModel data) {
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

  Widget motifDDWidget(MobilierModel data) {
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

  Future<void> submitDD(MobilierModel data) async {
    final mobilierModel = MobilierModel(
        id: data.id!,
        nom: data.nom,
        modele: data.modele,
        marque: data.marque,
        descriptionMobilier: data.descriptionMobilier,
        nombre: data.nombre,
        signature: data.signature,
        createdRef: data.createdRef,
        created: data.created,
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: widget.user.matricule);
    await MobilierApi().updateData(mobilierModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
