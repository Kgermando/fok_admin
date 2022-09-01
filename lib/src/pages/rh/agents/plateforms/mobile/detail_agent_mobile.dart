import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/administration/actionnaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/agent_pdf.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class DetailAgentMobile extends StatefulWidget {
  const DetailAgentMobile(
      {Key? key,
      required this.actionnaireList,
      required this.salaireList,
      required this.userList,
      required this.user,
      required this.agentModel})
      : super(key: key);
  final List<ActionnaireModel> actionnaireList;
  final List<PaiementSalaireModel> salaireList;
  final List<UserModel> userList;
  final UserModel user;
  final AgentModel agentModel;

  @override
  State<DetailAgentMobile> createState() => _DetailAgentMobileState();
}

class _DetailAgentMobileState extends State<DetailAgentMobile> {
  bool isLoading = false;
  bool isLoadingAction = false;

  bool statutAgent = false;

  @override
  Widget build(BuildContext context) {
    return pageDetail(widget.agentModel);
  }

  Widget pageDetail(AgentModel agentModel) {
    var actionnaire = widget.actionnaireList
        .where((element) => element.matricule == agentModel.matricule)
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(p16),
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(p10),
              border: Border.all(
                color: Colors.blueGrey.shade700,
                width: 2.0,
              ),
            ),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TitleWidget(title: 'Curriculum vitæ'),
                    Row(
                      children: [
                        if (int.parse(widget.user.role) == 0 &&
                            actionnaire.isEmpty)
                          IconButton(
                              color: Colors.red.shade700,
                              tooltip: 'Ajout Actionnaire',
                              onPressed: () {
                                actionnaireDialog(agentModel);
                              },
                              icon: const Icon(Icons.admin_panel_settings)),
                        PrintWidget(onPressed: () async {
                          await AgentPdf.generate(agentModel);
                        }),
                      ],
                    )
                  ],
                ),
                identiteWidget(agentModel),
                serviceWidet(agentModel),
                competenceExperienceWidet(agentModel),
                infosEditeurWidet(agentModel),
                const SizedBox(height: p20)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget identiteWidget(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 33,
                    backgroundColor: mainColor,
                    child: ClipOval(
                        child:
                            (agentModel.photo == '' || agentModel.photo == null)
                                ? Image.asset(
                                    'assets/images/avatar.jpg',
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  )
                                : Image.network(
                                    agentModel.photo!,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  )),
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: SfBarcodeGenerator(
                      value: agentModel.matricule,
                      symbology: QRCode(),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Statut agent : ',
                      textAlign: TextAlign.start,
                      style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                  (agentModel.statutAgent == 'true')
                      ? Text('Actif',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(color: Colors.green.shade700))
                      : Text('Inactif',
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(
                              color: Colors.orange.shade700))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const Text("Créé le:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(
                          DateFormat("dd-MM-yyyy HH:mm")
                              .format(agentModel.createdAt),
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const Text("Mise à jour le:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(
                          DateFormat("dd-MM-yyyy HH:mm")
                              .format(agentModel.created),
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Post-Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.postNom,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Prénom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.prenom,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Email :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.email,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Téléphone :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.telephone,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Sexe :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.sexe,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Niveau d\'accréditation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.role,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.matricule,
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(color: Colors.blueGrey)),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Numéro de sécurité sociale :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.numeroSecuriteSociale,
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(color: Colors.blueGrey)),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Lieu de naissance :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.lieuNaissance,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Date de naissance :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                    DateFormat("dd-MM-yyyy").format(agentModel.dateNaissance),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Nationalité :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.nationalite,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Adresse :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.adresse,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(
            height: p20,
          ),
        ],
      ),
    );
  }

  Widget serviceWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final role = int.parse(agentModel.role);
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Type de Contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.typeContrat,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: p20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Fonction occupée :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.fonctionOccupe,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: p20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(agentModel.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: p20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Services d\'affectation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SelectableText(agentModel.servicesAffectation,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: p20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Date de début du contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                    DateFormat("dd-MM-yyyy")
                        .format(agentModel.dateDebutContrat),
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: p20),
          if (agentModel.typeContrat == 'CDD')
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text('Date de fin du contrat :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                          DateFormat("dd-MM-yyyy")
                              .format(agentModel.dateFinContrat),
                          textAlign: TextAlign.start,
                          style: bodyMedium),
                    ),
                  ],
                )
              ],
            ),
          const SizedBox(height: p20),
          if (role <= 3)
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text('Salaire :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SelectableText("${agentModel.salaire} USD",
                          textAlign: TextAlign.start, style: bodyMedium),
                    ),
                  ],
                )
              ],
            ),
          const SizedBox(height: p20),
        ],
      ),
    );
  }

  Widget competenceExperienceWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Formation :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SelectableText(agentModel.competance!,
                        textAlign: TextAlign.justify, style: bodyMedium),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: p30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Experience :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SelectableText(agentModel.experience!,
                        textAlign: TextAlign.justify, style: bodyMedium),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget infosEditeurWidet(AgentModel agentModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Signature :',
              style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          SelectableText(agentModel.signature,
              textAlign: TextAlign.justify, style: bodyMedium)
        ],
      ),
    );
  }

  actionnaireDialog(AgentModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Etes vous sûr de faire ceci ?',
                  style: TextStyle(color: Colors.red.shade700)),
              content: isLoadingAction
                  ? Center(child: loading())
                  : Text("Cette action va crée un nouvel actionnaire",
                      style: Theme.of(context).textTheme.bodyLarge),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    isLoadingAction = true;
                    actionnaireSubmit(data).then((value) {
                      Navigator.pop(context, 'ok');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("Activation agent avec succès!"),
                        backgroundColor: Colors.green[700],
                      ));
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Future<void> actionnaireSubmit(AgentModel data) async {
    final actionnaireModel = ActionnaireModel(
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        sexe: data.sexe,
        matricule: data.matricule,
        signature: widget.user.matricule,
        createdRef: data.id!,
        created: DateTime.now());
    await ActionnaireApi().insertData(actionnaireModel);
  }
}
