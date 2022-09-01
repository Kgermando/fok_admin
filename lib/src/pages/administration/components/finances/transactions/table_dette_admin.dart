import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/finances/creance_dette_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/models/finances/creance_dette_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/dettes/dette_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableDetteAdmin extends StatefulWidget {
  const TableDetteAdmin({Key? key}) : super(key: key);

  @override
  State<TableDetteAdmin> createState() => _TableDetteAdminState();
}

class _TableDetteAdminState extends State<TableDetteAdmin> {
  Timer? timer;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;
  double paye = 0.0;
  double nonPaye = 0.0;

  @override
  initState() {
    agentsColumn();
    getData();
    agentsRow();

    super.initState();
  }

  List<DetteModel> dataList = [];
  List<CreanceDetteModel> creanceDetteList = [];
  Future<void> getData() async {
    List<DetteModel> dettes = await DetteApi().getAllData();
    var creanceDette = await CreanceDetteApi().getAllData();
    setState(() {
      List<DetteModel> data = dettes
          .where((element) =>
              element.approbationDG == "Approved" &&
              element.approbationDD == "Approved")
          .toList();
      creanceDetteList = creanceDette
          .where((element) => element.creanceDette == 'dettes')
          .toList();
      for (var item in data) {
        nonPaye += double.parse(item.montant);
      }

      for (var item in creanceDetteList) {
        paye += double.parse(item.montant);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: PlutoGrid(
              columns: columns,
              rows: rows,
              onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
                final dataId = tapEvent.row!.cells.values;
                final idPlutoRow = dataId.elementAt(0);
                Navigator.pushNamed(
                    context, FinanceRoutes.transactionsDetteDetail,
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
                    const TitleWidget(title: "Dettes"),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AdminRoutes.adminFinance);
                            },
                            icon: Icon(Icons.refresh,
                                color: Colors.green.shade700)),
                        PrintWidget(onPressed: () {
                          DetteXlsx().exportToExcel(dataList);
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
                    if (column.field == 'nomComplet') {
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
                    } else if (column.field == 'ligneBudgtaire') {
                      return resolver<ClassFilterImplemented>()
                          as PlutoFilterType;
                    } else if (column.field == 'departement') {
                      return resolver<ClassFilterImplemented>()
                          as PlutoFilterType;
                    } else if (column.field == 'typeOperation') {
                      return resolver<ClassFilterImplemented>()
                          as PlutoFilterType;
                    } else if (column.field == 'numeroOperation') {
                      return resolver<ClassFilterImplemented>()
                          as PlutoFilterType;
                    } else if (column.field == 'created') {
                      return resolver<ClassFilterImplemented>()
                          as PlutoFilterType;
                    }
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  },
                ),
              ),
            ),
          ),
          totalSolde()
        ],
      ),
    );
  }

  Widget totalSolde() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Card(
      color: Colors.red.shade700,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SelectableText('Total: ',
                    style: bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(paye + nonPaye)} \$',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
            Row(
              children: [
                SelectableText('Payé: ',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(paye)} \$',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
            Row(
              children: [
                SelectableText('Non Payé: ',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(nonPaye)} \$',
                    style: bodyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
            const SizedBox(
              width: 100,
            )
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
        title: 'Nom complet',
        field: 'nomComplet',
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
        title: 'Pièce justificative',
        field: 'pieceJustificative',
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
        title: 'Libelle',
        field: 'libelle',
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
        title: 'Montant',
        field: 'montant',
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
        title: 'Numero d\'operation',
        field: 'numeroOperation',
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
        title: 'Date',
        field: 'created',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<DetteModel?> dataList = await DetteApi().getAllData();
    var data = dataList
        .where((element) =>
            element!.approbationDG == '-' &&
            element.approbationDD == 'Approved')
        .toList(); // PAs de filtre parce le fichier approbation n'est pas encore crée

    if (mounted) {
      setState(() {
        for (var item in data) {
          id = item!.id;
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nomComplet': PlutoCell(value: item.nomComplet),
            'pieceJustificative': PlutoCell(value: item.pieceJustificative),
            'libelle': PlutoCell(value: item.libelle),
            'montant': PlutoCell(value: item.montant),
            'numeroOperation': PlutoCell(value: item.numeroOperation),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
