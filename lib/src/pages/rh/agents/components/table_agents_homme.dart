import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/agents_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableAgentsHomme extends StatefulWidget {
  const TableAgentsHomme({Key? key}) : super(key: key);

  @override
  State<TableAgentsHomme> createState() => _TableAgentsHommeState();
}

class _TableAgentsHommeState extends State<TableAgentsHomme> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  initState() {
    agentsColumn();
    agentsRow();
    getData();
    super.initState();
  }

  List<AgentModel> dataList = [];
  Future<void> getData() async {
    List<AgentModel> data = await AgentsApi().getAllData();

    setState(() {
      dataList = data.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const DrawerMenu(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Nouveau profil",
        onPressed: () {
          Navigator.pushNamed(context, RhRoutes.rhAgentAdd);
        },
        child: const Icon(Icons.person_add),
      ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppbar(
                        title: (Responsive.isDesktop(context))
                            ? "Ressources Humaines"
                            : "RH",
                        controllerMenu: () => _key.currentState!.openDrawer()),
                    Expanded(
                      child: PlutoGrid(
                        columns: columns,
                        rows: rows,
                        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
                          final dataId = tapEvent.row!.cells.values;
                          final idPlutoRow = dataId.elementAt(0);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => AgentPage(id: idPlutoRow.value)));
                          Navigator.pushNamed(context, RhRoutes.rhAgentPage,
                              arguments: idPlutoRow.value);
                        },
                        onLoaded: (PlutoGridOnLoadedEvent event) {
                          stateManager = event.stateManager;
                          stateManager!.setShowColumnFilter(true);
                          stateManager!.notifyListeners();
                        },
                        createHeader: (PlutoGridStateManager header) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleWidget(title: "Personnels"),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, RhRoutes.rhAgent);
                                      },
                                      icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                                  PrintWidget(onPressed: () {
                                    AgentXlsx().exportToExcel(dataList);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: const Text("Exportation effectué!"),
                                      backgroundColor: Colors.green[700],
                                    ));
                                  })
                                ],
                              ),
                            ],
                          );
                        },
                        configuration: PlutoGridConfiguration(
                          columnFilter: PlutoGridColumnFilterConfig(
                            filters: const [
                              ...FilterHelper.defaultFilters,
                              // custom filter
                              ClassFilterImplemented(),
                            ],
                            resolveDefaultColumnFilter: (column, resolver) {
                              if (column.field == 'id') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'nom') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'postNom') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'prenom') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'email') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'telephone') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'sexe') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'role') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'matricule') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'dateNaissance') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'departement') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'servicesAffectation') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              } else if (column.field == 'statutAgent') {
                                return resolver<ClassFilterImplemented>() as PlutoFilterType;
                              }
                              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'Id',
        field: 'id',
        type: PlutoColumnType.number(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 100,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Nom',
        field: 'nom',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Post-Nom',
        field: 'postNom',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Prénom',
        field: 'prenom',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Email',
        field: 'email',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 300,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'telephone',
        field: 'telephone',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'sexe',
        field: 'sexe',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Acréditation',
        field: 'role',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Matricule',
        field: 'matricule',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Date de naissance',
        field: 'dateNaissance',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Département',
        field: 'departement',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 250,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Services d\'affectation',
        field: 'servicesAffectation',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 300,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Statut Agent',
        field: 'statutAgent',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<AgentModel?> agents = await AgentsApi().getAllData();
    var data =
        agents.where((element) => element!.sexe == 'Homme').toList();
    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'nom': PlutoCell(value: item.nom),
            'postNom': PlutoCell(value: item.postNom),
            'prenom': PlutoCell(value: item.prenom),
            'email': PlutoCell(value: item.email),
            'telephone': PlutoCell(value: item.telephone),
            'sexe': PlutoCell(value: item.sexe),
            'role': PlutoCell(value: "Niveau ${item.role}"),
            'matricule': PlutoCell(value: item.matricule),
            'dateNaissance': PlutoCell(
                value: DateFormat("dd-MM-yyyy").format(item.createdAt)),
            'departement': PlutoCell(value: item.departement),
            'servicesAffectation': PlutoCell(value: item.servicesAffectation),
            'statutAgent': PlutoCell(
                value: (item.statutAgent == "true")
                    ? 'Agent actif'
                    : 'Agent Homme')
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
