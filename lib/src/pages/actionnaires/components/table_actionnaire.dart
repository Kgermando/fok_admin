import 'package:fokad_admin/src/pages/actionnaires/components/actionnaire_xlsx.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/administration/actionnaire_api.dart';
import 'package:fokad_admin/src/api/administration/actionnaire_cotisation_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_cotisation_model.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/dash_number_budget_widget.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableActionnaire extends StatefulWidget {
  const TableActionnaire({Key? key}) : super(key: key);

  @override
  State<TableActionnaire> createState() => _TableActionnaireState();
}

class _TableActionnaireState extends State<TableActionnaire> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    agentsColumn();
    agentsRow();
    getData();
    super.initState();
  }

  List<ActionnaireModel> dataList = [];

  List<ActionnaireCotisationModel> actionnaireCotisationList = [];
  List<ActionnaireCotisationModel> actionnaireCotisationMonthList = [];

  double totalGen = 0.0;
  double totalMonth = 0.0;

  Future<void> getData() async {
    List<ActionnaireModel> actionnaires = await ActionnaireApi().getAllData();
    List<ActionnaireCotisationModel> actionnaireCotisations =
        await ActionnaireCotisationApi().getAllData();

    setState(() {
      dataList = actionnaires.toList();

      actionnaireCotisationList = actionnaireCotisations.toList();
      actionnaireCotisationMonthList = actionnaireCotisations
          .where((element) => element.created.month == DateTime.now().month)
          .toList();

      for (var item in actionnaireCotisationList) {
        totalGen += double.parse(item.montant);
      }

      for (var item in actionnaireCotisationMonthList) {
        totalMonth += double.parse(item.montant);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: p20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashNumberBudgetWidget(
                gestureTapCallback: () {},
                number:
                    "${NumberFormat.decimalPattern('fr').format(totalGen)} \$",
                title: "Total général",
                icon: Icons.date_range,
                color: Colors.green.shade700),
            DashNumberBudgetWidget(
                gestureTapCallback: () {},
                number:
                    "${NumberFormat.decimalPattern('fr').format(totalMonth)} \$",
                title: "Total de ce mois",
                icon: Icons.date_range_outlined,
                color: Colors.red.shade700),
          ],
        ),
        const SizedBox(height: p20),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
              final dataId = tapEvent.row!.cells.values;
              final idPlutoRow = dataId.elementAt(0);

              Navigator.pushNamed(context, ActionnaireRoute.actionnairePage,
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
                  const TitleWidget(title: "Actionnaires"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ActionnaireRoute.actionnairePage);
                          },
                          icon: Icon(Icons.refresh,
                              color: Colors.green.shade700)),
                      PrintWidget(onPressed: () {
                        ActionnaireXlsx().exportToExcel(dataList);
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
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'nom') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'postNom') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'prenom') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'email') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'telephone') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'sexe') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'matricule') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'signature') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'created') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  }
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                },
              ),
            ),
          ),
        ),
      ],
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
        width: 200,
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
        width: 200,
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
        width: 200,
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
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Téléphone',
        field: 'telephone',
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
        title: 'Sexe',
        field: 'sexe',
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
        title: 'Signature',
        field: 'signature',
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
        title: 'Date',
        field: 'created',
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
    List<ActionnaireModel> actionnaires = await ActionnaireApi().getAllData();

    if (mounted) {
      setState(() {
        for (var item in actionnaires) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nom': PlutoCell(value: item.nom),
            'postNom': PlutoCell(value: item.postNom),
            'prenom': PlutoCell(value: item.prenom),
            'email': PlutoCell(value: item.email),
            'telephone': PlutoCell(value: item.telephone),
            'sexe': PlutoCell(value: item.sexe),
            'matricule': PlutoCell(value: item.matricule),
            'signature': PlutoCell(value: item.signature),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
        }

        // for (var item in actionnaires) {
        //   var cotisations = actionnaireCotisations
        //       .where((element) => element.reference == item.id)
        //       .toList();

        //   for (var element in cotisations) {
        //     total += double.parse(element.montant);
        //   }

        //   rows.add(PlutoRow(cells: {
        //     'id': PlutoCell(value: item.id),
        //     'nom': PlutoCell(value: item.nom),
        //     'postNom': PlutoCell(value: item.postNom),
        //     'prenom': PlutoCell(value: item.prenom),
        //     'email': PlutoCell(value: item.email),
        //     'telephone': PlutoCell(value: item.telephone),
        //     'sexe': PlutoCell(value: item.sexe),
        //     'matricule': PlutoCell(value: item.matricule),
        //     'total': PlutoCell(
        //         value: "${NumberFormat.decimalPattern('fr').format(total)} \$"),
        //     'signature': PlutoCell(value: item.signature),
        //     'created': PlutoCell(
        //         value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
        //   }));
        // }
        stateManager!.resetCurrentState();
      });
    }
  }
}
