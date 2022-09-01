import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/salaire_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableSalaires extends StatefulWidget {
  const TableSalaires({Key? key}) : super(key: key);

  @override
  State<TableSalaires> createState() => _TableSalairesState();
}

class _TableSalairesState extends State<TableSalaires> {
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

  List<PaiementSalaireModel> paiementSalaireList = [];
  Future<void> getData() async {
    var dataList = await PaiementSalaireApi().getAllData();

    setState(() {
      paiementSalaireList = dataList.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
        final dataId = tapEvent.row!.cells.values;
        final idPlutoRow = dataId.elementAt(0);

        Navigator.pushNamed(context, RhRoutes.rhPaiementBulletin,
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
            const TitleWidget(title: "Salaires"),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RhRoutes.rhPaiement);
                    },
                    icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                PrintWidget(onPressed: () {
                  SalaireXlsx().exportToExcel(paiementSalaireList);
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
            } else if (column.field == 'prenom') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'nom') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'matricule') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'departement') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'observation') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'modePaiement') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'salaire') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'created') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationDD') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationBudget') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationFin') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            }
            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          },
        ),
      ),
      rowColorCallback: (rowColorContext) {
        if (rowColorContext.row.cells.entries
                    .elementAt(8)
                    .value
                    .value ==
                'Unapproved' ||
            rowColorContext.row.cells.entries.elementAt(9).value.value ==
                'Unapproved' ||
            rowColorContext.row.cells.entries.elementAt(10).value.value ==
                'Unapproved') {
          return Colors.red.shade700;
        } else if (rowColorContext.row.cells.entries.elementAt(8).value.value ==
                'Approved' &&
            rowColorContext.row.cells.entries.elementAt(9).value.value ==
                'Approved' &&
            rowColorContext.row.cells.entries.elementAt(10).value.value ==
                'Approved') {
          return Colors.green.shade700;
        }
        return Colors.white;
      },
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
        title: 'Département',
        field: 'departement',
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
        title: 'Observation',
        field: 'observation',
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
        title: 'Mode de paiement',
        field: 'modePaiement',
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
        field: 'createdAt',
        type: PlutoColumnType.date(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Approbation DD',
        field: 'approbationDD',
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
        title: 'Approbation Budget',
        field: 'approbationBudget',
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
        title: 'Approbation Fin',
        field: 'approbationFin',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 300,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<PaiementSalaireModel?> dataList =
        await PaiementSalaireApi().getAllData();

    // Uniquement ceux qui ont déjà été approuvé
    var data = dataList
        // .where((element) =>
        //     element!.createdAt.month == DateTime.now().month &&
        //     element.createdAt.year == DateTime.now().year &&
        //     element.approbationDD == 'Approved' &&
        //     element.approbationBudget == 'Approved' &&
        //     element.approbationFin == 'Approved' &&
        //     element.observation == 'true')
        .toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'prenom': PlutoCell(value: item.prenom),
            'nom': PlutoCell(value: item.nom),
            'matricule': PlutoCell(value: item.matricule),
            'departement': PlutoCell(value: item.departement),
            'observation': PlutoCell(
                value: (item.observation == 'true') ? "Payé" : "Non payé"),
            'modePaiement': PlutoCell(value: item.modePaiement),
            'createdAt': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.createdAt)),
            'approbationDD': PlutoCell(value: item.approbationDD),
            'approbationBudget': PlutoCell(value: item.approbationBudget),
            'approbationFin': PlutoCell(value: item.approbationFin),
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
