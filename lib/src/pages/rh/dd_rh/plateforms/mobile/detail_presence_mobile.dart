import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/presence_personnel_model.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPresenceMobile extends StatefulWidget {
  const DetailPresenceMobile(
      {Key? key,
      required this.presencePersonnelList,
      required this.agent,
      required this.presencePersonnelListTotal})
      : super(key: key);
  final List<PresencePersonnelModel> presencePersonnelList;
  final AgentModel agent;
  final List<PresencePersonnelModel> presencePersonnelListTotal;

  @override
  State<DetailPresenceMobile> createState() => _DetailPresenceMobileState();
}

class _DetailPresenceMobileState extends State<DetailPresenceMobile> {
  final ScrollController controllerTable = ScrollController();
  final ScrollController controllerTable2 = ScrollController();
  final ScrollController controllerTable3 = ScrollController();

  int isHoursCumulsWork = 0; // Nombre dheures depuis le debut de travail
  int isJoursWork = 0; // Nombre des jours dans un mois
  int isHoursWork = 0; // Nombre des Heures dans un mois

  @override
  void initState() {
    for (var element in widget.presencePersonnelListTotal) {
      isHoursCumulsWork += element.createdSortie.hour - element.created.hour;
    }

    isJoursWork += widget.presencePersonnelList.length;

    for (var element in widget.presencePersonnelList) {
      isHoursWork += element.createdSortie.hour - element.created.hour;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return pageDetail();
  }

  Widget pageDetail() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dataWidget(),
                    const TitleWidget(title: "Cumuls générale"),
                    Scrollbar(
                      controller: controllerTable,
                      child: Padding(
                        padding: const EdgeInsets.all(p10),
                        child: tableCumuls(),
                      ),
                    ),
                    const TitleWidget(title: "Par mois"),
                    Scrollbar(
                      controller: controllerTable2,
                      child: Padding(
                        padding: const EdgeInsets.all(p10),
                        child: tableTotal(),
                      ),
                    ),
                    Scrollbar(
                      controller: controllerTable3,
                      child: Padding(
                        padding: const EdgeInsets.all(p10),
                        child: tableListAgents(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]);
  }

  Widget dataWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Prénom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(widget.agent.prenom,
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
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(widget.agent.nom,
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
                flex: 2,
                child: Text('PostNom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(widget.agent.postNom,
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
                flex: 2,
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(widget.agent.matricule,
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

  Widget tableCumuls() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controllerTable,
      child: Container(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: Table(
          border: TableBorder.all(color: Colors.red),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(3),
          },
          children: [
            tableRowCumuls(),
          ],
        ),
      ),
    );
  }

  TableRow tableRowCumuls() {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Cumuls d'Heures"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText("$isHoursCumulsWork Heures"),
      ),
    ]);
  }

  Widget tableTotal() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controllerTable2,
      child: Container(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: Table(
          border: TableBorder.all(color: Colors.purple),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(3),
          },
          children: [tableRowHeaderTotal(), tableRowTotal()],
        ),
      ),
    );
  }

  TableRow tableRowHeaderTotal() {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Total des jours"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Total d'heures de travail"),
      ),
    ]);
  }

  TableRow tableRowTotal() {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText("$isJoursWork jours"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText("$isHoursWork heures"),
      ),
    ]);
  }

  Widget tableListAgents() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controllerTable3,
      child: Container(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(3),
          },
          children: [
            tableRowHeader(),
            for (var item in widget.presencePersonnelList) tableRow(item)
          ],
        ),
      ),
    );
  }

  TableRow tableRowHeader() {
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Date"),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: const AutoSizeText("Nombre d'heures par jour"),
      ),
    ]);
  }

  TableRow tableRow(PresencePersonnelModel item) {
    int isHoursWork = 0;
    isHoursWork = item.createdSortie.hour - item.created.hour;
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText(DateFormat("dd-MM-yyyy").format(item.created)),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: AutoSizeText("$isHoursWork heures"),
      ),
    ]);
  }
}
