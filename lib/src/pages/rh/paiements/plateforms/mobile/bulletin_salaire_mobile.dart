import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/salaire_pdf.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class BulletinSalaireMobile extends StatefulWidget {
  const BulletinSalaireMobile(
      {Key? key,
      required this.departementsList,
      required this.ligneBudgetaireList,
      required this.user,
      required this.paiementSalaireModel})
      : super(key: key);
  final List<DepartementBudgetModel> departementsList;
  final List<LigneBudgetaireModel> ligneBudgetaireList;
  final UserModel user;
  final PaiementSalaireModel paiementSalaireModel;

  @override
  State<BulletinSalaireMobile> createState() => _BulletinSalaireMobileState();
}

class _BulletinSalaireMobileState extends State<BulletinSalaireMobile> {
  final _formKeyBudget = GlobalKey<FormState>();
  bool isLoading = false;

  bool isChecked = false;

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

  String? paye;

  @override
  void dispose() {
    motifDGController.dispose();
    motifBudgetController.dispose();
    motifFinController.dispose();
    motifDDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        bulletinPaieWidget(widget.paiementSalaireModel),
        const SizedBox(height: p10),
        approbationWidget(widget.paiementSalaireModel)
      ],
    ));
  }

  Widget bulletinPaieWidget(PaiementSalaireModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(p10),
            padding: const EdgeInsets.all(p10),
            width: MediaQuery.of(context).size.width / 1.2,
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
                    TitleWidget(
                        title:
                            "Du ${DateFormat("dd-MM-yyyy HH:mm").format(data.createdAt)}"),
                    Row(
                      children: [
                        PrintWidget(onPressed: () async {
                          await SalairePdf.generate(data);
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: p20,
                ),
                agentWidget(data),
                const SizedBox(
                  height: p20,
                ),
                salaireWidget(data),
                const SizedBox(
                  height: p20,
                ),
                heureSupplementaireWidget(data),
                const SizedBox(
                  height: p20,
                ),
                supplementTravailSamediDimancheJoursFerieWidget(data),
                const SizedBox(
                  height: p20,
                ),
                primeWidget(data),
                const SizedBox(
                  height: p20,
                ),
                diversWidget(data),
                const SizedBox(
                  height: p20,
                ),
                congesPayeWidget(data),
                const SizedBox(
                  height: p20,
                ),
                maladieAccidentWidget(data),
                const SizedBox(
                  height: p20,
                ),
                totalDuBrutWidget(data),
                const SizedBox(
                  height: p20,
                ),
                deductionWidget(data),
                const SizedBox(
                  height: p20,
                ),
                allocationsFamilialesWidget(data),
                const SizedBox(
                  height: p20,
                ),
                netAPayerWidget(data),
                const SizedBox(
                  height: p20,
                ),
                montantPrisConsiderationCalculCotisationsINSSWidget(data),
                const SizedBox(
                  height: p20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget agentWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Matricule',
                style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.matricule,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
          children: [
            Expanded(
              child: Text(
                'Numéro de securité sociale',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.numeroSecuriteSociale,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
          children: [
            Expanded(
              child: Text(
                'Nom',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.nom,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
          children: [
            Expanded(
              child: Text(
                'Prénom',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.prenom,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
          children: [
            Expanded(
              child: Text(
                'Téléphone',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.telephone,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
          children: [
            Expanded(
              child: Text(
                'Adresse',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.adresse,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
          children: [
            Expanded(
              child: Text(
                'Département',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.departement,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
          children: [
            Expanded(
              child: Text(
                'Services d\'affectation',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.servicesAffectation,
              style: bodyMedium,
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
          children: [
            Expanded(
              child: Text(
                'Salaire',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              "${NumberFormat.decimalPattern('fr').format(double.parse(data.salaire))} USD",
              style: bodyMedium.copyWith(color: Colors.blueGrey),
            ))
          ],
        ),
        Divider(color: mainColor),
        Row(
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
                widget.user.departement == "Finances")
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
        Row(
          children: [
            Expanded(
              child: Text(
                'Mode de paiement',
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: p10,
            ),
            Expanded(
                child: SelectableText(
              data.modePaiement,
              style: bodyMedium,
            ))
          ],
        ),
      ],
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

  checkboxRead(PaiementSalaireModel data) {
    isChecked = false;
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

  Widget salaireWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: mainColor),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Salaires',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Durée',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.tauxJourHeureMoisSalaire,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text('%', style: bodySmall)),
              Expanded(
                child: SelectableText(
                  data.joursHeuresPayeA100PourecentSalaire,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text('Total dû', style: bodySmall)),
              Expanded(
                child: SelectableText(
                  (data.totalDuSalaire == '-')
                      ? data.totalDuSalaire
                      : "${NumberFormat.decimalPattern('fr').format(double.parse(data.totalDuSalaire))} USD",
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget heureSupplementaireWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Heure supplementaire',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Nombre Heure',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.nombreHeureSupplementaires,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Taux',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.tauxHeureSupplementaires,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total dû',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.totalDuHeureSupplementaires,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget supplementTravailSamediDimancheJoursFerieWidget(
      PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                      'Supplement dû travail du samedi, du dimanche et jours ferié',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Supplement dû travail',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.supplementTravailSamediDimancheJoursFerie,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget primeWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Prime',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Prime',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.prime,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget diversWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Divers',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Divers',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.divers,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget congesPayeWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Congés Payé',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Jours',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.joursCongesPaye,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Taux',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.tauxCongesPaye,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total dû',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.totalDuHeureSupplementaires,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget maladieAccidentWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Maladie ou Accident',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Jours Payé',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.jourPayeMaladieAccident,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Taux',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.tauxJournalierMaladieAccident,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total dû',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.totalDuMaladieAccident,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget totalDuBrutWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Total brut dû',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.totalDuBrut,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget deductionWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Deduction',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pension',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.pensionDeduction,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Indemnité compensatrices',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.indemniteCompensatricesDeduction,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Avances',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.avancesDeduction,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Divers',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.diversDeduction,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Retenues fiscales',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.retenuesFiscalesDeduction,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget allocationsFamilialesWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Allocations familiales',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    'Nombre des enfants béneficaire',
                    textAlign: TextAlign.center,
                    style: bodySmall,
                  ),
                  SelectableText(
                    data.nombreEnfantBeneficaireAllocationsFamiliales,
                    style: bodyMedium,
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    'Nombre des Jours',
                    style: bodySmall,
                  ),
                  SelectableText(
                    data.nombreDeJoursAllocationsFamiliales,
                    style: bodyMedium,
                  ),
                ],
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'Taux journalier',
                        style: bodySmall,
                      ),
                      SelectableText(
                        data.tauxJoursAllocationsFamiliales,
                        style: bodyMedium,
                      ),
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'Total à payer',
                        style: bodySmall,
                      ),
                      SelectableText(
                        data.totalAPayerAllocationsFamiliales,
                        style: bodyMedium,
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget netAPayerWidget(PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Net à payer',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total à payer',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.netAPayer,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget montantPrisConsiderationCalculCotisationsINSSWidget(
      PaiementSalaireModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.only(top: p10, bottom: p10),
      decoration: BoxDecoration(
        border: Border(
          // top: BorderSide(width: 1.0),
          bottom: BorderSide(width: 1.0, color: mainColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                      'Montant pris en consideration pour le calcul des cotisations INSS',
                      style:
                          bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: p10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Montant pris pour la Cotisations INSS',
                  style: bodySmall,
                ),
              ),
              Expanded(
                child: SelectableText(
                  data.montantPrisConsiderationCalculCotisationsINSS,
                  style: bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> submitObservation(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: 'true',
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
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
    await PaiementSalaireApi().updateData(paiementSalaireModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Mise à jour avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Widget approbationWidget(PaiementSalaireModel data) {
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
                    Text("Directeur de departement",
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
              const SizedBox(height: p20),
              Divider(color: Colors.red[10]),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Column(
                  children: [
                    Text("Budget",
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
                                          Text(data.approbationBudget,
                                              style: bodyLarge.copyWith(
                                                  color:
                                                      (data.approbationBudget ==
                                                              "Unapproved")
                                                          ? Colors.red.shade700
                                                          : Colors
                                                              .green.shade700)),
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
                                                  color:
                                                      Colors.purple.shade700)),
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
                                                  color:
                                                      Colors.purple.shade700)),
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
                                          ligneBudgtaireWidget(),
                                          const SizedBox(width: p20),
                                          resourcesWidget(),
                                          const SizedBox(width: p20),
                                          approbationBudgetWidget(data),
                                          const SizedBox(width: p20),
                                          if (approbationBudget == "Unapproved")
                                            motifBudgetWidget(data)
                                        ],
                                      ),
                                    ),
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
                    Text("Finance",
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
                                    child: Column(children: [
                                      approbationFinWidget(data),
                                      const SizedBox(width: p20),
                                      if (approbationFin == "Unapproved")
                                        motifFinWidget(data)
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

  Widget approbationDDWidget(PaiementSalaireModel data) {
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

  Widget motifDDWidget(PaiementSalaireModel data) {
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

  Widget approbationBudgetWidget(PaiementSalaireModel data) {
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

  Widget motifBudgetWidget(PaiementSalaireModel data) {
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

  Widget approbationFinWidget(PaiementSalaireModel data) {
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

  Widget motifFinWidget(PaiementSalaireModel data) {
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

  Future<void> submitDD(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: data.observation,
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
        approbationBudget: 'Approved',
        motifBudget: '-',
        signatureBudget: '-',
        approbationFin: 'Approved',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: approbationDD,
        motifDD: (motifDDController.text == '') ? '-' : motifDDController.text,
        signatureDD: widget.user.matricule,
        ligneBudgetaire: '-',
        ressource: '-');
    await PaiementSalaireApi().updateData(paiementSalaireModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitBudget(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: data.observation,
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
        approbationBudget: approbationBudget,
        motifBudget: (motifBudgetController.text == '')
            ? '-'
            : motifBudgetController.text,
        signatureBudget: widget.user.matricule,
        approbationFin: 'Approved',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire:
            (ligneBudgtaire.toString() == '') ? '-' : ligneBudgtaire.toString(),
        ressource: (ressource.toString() == '') ? '-' : ressource.toString());
    await PaiementSalaireApi().updateData(paiementSalaireModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitFin(PaiementSalaireModel data) async {
    final paiementSalaireModel = PaiementSalaireModel(
        id: data.id,
        nom: data.nom,
        postNom: data.postNom,
        prenom: data.prenom,
        email: data.email,
        telephone: data.telephone,
        adresse: data.adresse,
        departement: data.departement,
        numeroSecuriteSociale: data.numeroSecuriteSociale,
        matricule: data.matricule,
        servicesAffectation: data.servicesAffectation,
        salaire: data.salaire,
        observation: data.observation,
        modePaiement: data.modePaiement,
        createdAt: data.createdAt,
        tauxJourHeureMoisSalaire: data.tauxJourHeureMoisSalaire,
        joursHeuresPayeA100PourecentSalaire:
            data.joursHeuresPayeA100PourecentSalaire,
        totalDuSalaire: data.totalDuSalaire,
        nombreHeureSupplementaires: data.nombreHeureSupplementaires,
        tauxHeureSupplementaires: data.tauxHeureSupplementaires,
        totalDuHeureSupplementaires: data.totalDuHeureSupplementaires,
        supplementTravailSamediDimancheJoursFerie:
            data.supplementTravailSamediDimancheJoursFerie,
        prime: data.prime,
        divers: data.divers,
        joursCongesPaye: data.joursCongesPaye,
        tauxCongesPaye: data.tauxCongesPaye,
        totalDuCongePaye: data.totalDuCongePaye,
        jourPayeMaladieAccident: data.jourPayeMaladieAccident,
        tauxJournalierMaladieAccident: data.tauxJournalierMaladieAccident,
        totalDuMaladieAccident: data.totalDuMaladieAccident,
        pensionDeduction: data.pensionDeduction,
        indemniteCompensatricesDeduction: data.indemniteCompensatricesDeduction,
        avancesDeduction: data.avancesDeduction,
        diversDeduction: data.diversDeduction,
        retenuesFiscalesDeduction: data.retenuesFiscalesDeduction,
        nombreEnfantBeneficaireAllocationsFamiliales:
            data.nombreEnfantBeneficaireAllocationsFamiliales,
        nombreDeJoursAllocationsFamiliales:
            data.nombreDeJoursAllocationsFamiliales,
        tauxJoursAllocationsFamiliales: data.tauxJoursAllocationsFamiliales,
        totalAPayerAllocationsFamiliales: data.totalAPayerAllocationsFamiliales,
        netAPayer: data.netAPayer,
        montantPrisConsiderationCalculCotisationsINSS:
            data.montantPrisConsiderationCalculCotisationsINSS,
        totalDuBrut: data.totalDuBrut,
        signature: data.signature,
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
        ressource: data.ressource);
    await PaiementSalaireApi().updateData(paiementSalaireModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
    await send(data).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Mail envoyer à ${data.prenom} ${data.nom}"),
        backgroundColor: Colors.green[400],
      ));
    });
  }

  Future<void> send(PaiementSalaireModel data) async {
    String mois = '';
    if (DateTime.now().month == 1) {
      mois = 'Janvier';
    } else if (DateTime.now().month == 2) {
      mois = 'Février';
    } else if (DateTime.now().month == 3) {
      mois = 'Mars';
    } else if (DateTime.now().month == 4) {
      mois = 'Avril';
    } else if (DateTime.now().month == 5) {
      mois = 'Mai';
    } else if (DateTime.now().month == 6) {
      mois = 'Juin';
    } else if (DateTime.now().month == 7) {
      mois = 'Juillet';
    } else if (DateTime.now().month == 8) {
      mois = 'Août';
    } else if (DateTime.now().month == 9) {
      mois = 'Septembre';
    } else if (DateTime.now().month == 10) {
      mois = 'Octobre';
    } else if (DateTime.now().month == 11) {
      mois = 'Novembre';
    } else if (DateTime.now().month == 12) {
      mois = 'Décembre';
    }
    final mailModel = MailModel(
        fullName: "${data.prenom} ${data.nom}",
        email: data.email,
        cc: '-',
        objet: "SALAIRE",
        message:
            "Bonjour ${data.prenom}, votre salaire de $mois est maintenant disponible.",
        pieceJointe: "-",
        read: 'false',
        fullNameDest: "${widget.user.prenom} ${widget.user.nom}",
        emailDest: widget.user.email,
        dateSend: DateTime.now(),
        dateRead: DateTime.now());
    await MailApi().insertData(mailModel);
  }
}
