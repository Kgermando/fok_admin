import 'dart:async';

import 'package:fokad_admin/src/pages/finances/transactions/plateforms/desktop/solde_dette_creance_desktop.dart';
import 'package:fokad_admin/src/pages/finances/transactions/plateforms/mobile/solde_dette_creance_mobile.dart';
import 'package:fokad_admin/src/pages/finances/transactions/plateforms/tablet/solde_dette_creance_tablet.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/creance_dette_api.dart';
import 'package:fokad_admin/src/models/finances/creance_dette_model.dart';
import 'package:fokad_admin/src/models/finances/creances_model.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/creances/creance_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCreance extends StatefulWidget {
  const TableCreance({Key? key}) : super(key: key);

  @override
  State<TableCreance> createState() => _TableCreanceState();
}

class _TableCreanceState extends State<TableCreance> {
  Timer? timer;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  double nonPaye = 0.0; // total Créance
  double paye = 0.0; // total creanceDette

  @override
  initState() {
    agentsColumn();
    getData();
    agentsRow();
    super.initState();
  }

  List<CreanceModel> dataList = [];
  List<CreanceDetteModel> creanceDetteList = [];

  Future<void> getData() async {
    List<CreanceModel> creances = await CreanceApi().getAllData();
    var creanceDette = await CreanceDetteApi().getAllData();
    setState(() {
      List<CreanceModel?> data = creances
          .where((element) =>
              element.approbationDG == "Approved" &&
              element.approbationDD == "Approved")
          .toList();
      creanceDetteList = creanceDette
          .where((element) => element.creanceDette == 'creances')
          .toList();

      for (var item in data) {
        nonPaye += double.parse(item!.montant);
      }

      for (var item in creanceDetteList) {
        paye += double.parse(item.montant);
      }

      dataList = creances.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
              final dataId = tapEvent.row!.cells.values;
              final idPlutoRow = dataId.elementAt(0);
              Navigator.pushNamed(
                  context, FinanceRoutes.transactionsCreanceDetail,
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
                  const TitleWidget(title: "Créances"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, FinanceRoutes.transactionsCreances);
                          },
                          icon: Icon(Icons.refresh,
                              color: Colors.green.shade700)),
                      PrintWidget(onPressed: () {
                        CreanceXlsx().exportToExcel(dataList);
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
                  } else if (column.field == 'nomComplet') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'pieceJustificative') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'libelle') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'montant') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'numeroOperation') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'created') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'approbationDG') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  } else if (column.field == 'approbationDD') {
                    return resolver<ClassFilterImplemented>()
                        as PlutoFilterType;
                  }
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                },
              ),
            ),
            rowColorCallback: (rowColorContext) {
              if (rowColorContext.row.cells.entries.elementAt(7).value.value ==
                      'Unapproved' ||
                  rowColorContext.row.cells.entries.elementAt(8).value.value ==
                      'Unapproved') {
                return Colors.red.shade700;
              } else if (rowColorContext.row.cells.entries
                          .elementAt(7)
                          .value
                          .value ==
                      'Approved' &&
                  rowColorContext.row.cells.entries.elementAt(8).value.value ==
                      'Approved') {
                return Colors.green.shade700;
              }
              return Colors.white;
            },
          ),
        ),
        totalSolde()
      ],
    );
  }

  Widget totalSolde() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1100) {
        return SoldeDetteCreanceDesktop(nonPaye: nonPaye, paye: paye);
      } else if (constraints.maxWidth < 1100 && constraints.maxWidth >= 650) {
        return SoldeDetteCreanceTablet(nonPaye: nonPaye, paye: paye);
      } else {
        return SoldeDetteCreanceMobile(nonPaye: nonPaye, paye: paye);
      }
    });
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
        title: 'Nom complet',
        field: 'nomComplet',
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
        title: 'Pièce justificative',
        field: 'pieceJustificative',
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
        title: 'Libelle',
        field: 'libelle',
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
        title: 'Montant',
        field: 'montant',
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
        title: 'Numero d\'operation',
        field: 'numeroOperation',
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
      PlutoColumn(
        readOnly: true,
        title: 'Approbation DG',
        field: 'approbationDG',
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
    ];
  }

  Future agentsRow() async {
    List<CreanceModel> creances = await CreanceApi().getAllData();
    // UserModel userModel = await AuthApi().getUserId();
    var data = creances.toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nomComplet': PlutoCell(value: item.nomComplet),
            'pieceJustificative': PlutoCell(value: item.pieceJustificative),
            'libelle': PlutoCell(value: item.libelle),
            'montant': PlutoCell(
                value:
                    "${NumberFormat.decimalPattern('fr').format(double.parse(item.montant))} \$"),
            'numeroOperation': PlutoCell(value: item.numeroOperation),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created)),
            'approbationDG': PlutoCell(value: item.approbationDG),
            'approbationDD': PlutoCell(value: item.approbationDD)
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
