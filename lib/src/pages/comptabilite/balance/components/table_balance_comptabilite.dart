import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comptabilite/balance_compte_api.dart';
import 'package:fokad_admin/src/models/comptabilites/balance_comptes_model.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/components/balance_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableBilanComptabilite extends StatefulWidget {
  const TableBilanComptabilite({Key? key}) : super(key: key);

  @override
  State<TableBilanComptabilite> createState() => _TableBilanComptabiliteState();
}

class _TableBilanComptabiliteState extends State<TableBilanComptabilite> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  initState() {
    agentsColumn();
    getData();
    agentsRow();

    super.initState();
  }

  List<BalanceCompteModel> dataList = [];
  Future<void> getData() async {
    List<BalanceCompteModel> balances = await BalanceCompteApi().getAllData();
    setState(() {
      dataList = balances
          // .where((element) =>
          //     element.approbationDG == "Approved" &&
          //     element.approbationDD == "Approved")
          .toList();
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
        Navigator.pushNamed(
            context, ComptabiliteRoutes.comptabiliteBalanceDetail,
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
            const TitleWidget(title: "Balances"),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ComptabiliteRoutes.comptabiliteBalance);
                    },
                    icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                PrintWidget(onPressed: () {
                  BalanceXlsx().exportToExcel(dataList);
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
            } else if (column.field == 'titleBilan') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'signature') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'created') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationDG') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationDD') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            }
            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          },
        ),
      ),
      rowColorCallback: (rowColorContext) {
        if (rowColorContext.row.cells.entries.elementAt(4).value.value ==
                'Unapproved' ||
            rowColorContext.row.cells.entries.elementAt(5).value.value ==
                'Unapproved') {
          return Colors.red.shade700;
        } else if (rowColorContext.row.cells.entries.elementAt(4).value.value ==
                'Approved' &&
            rowColorContext.row.cells.entries.elementAt(5).value.value ==
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
        title: 'Titre',
        field: 'title',
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
    List<BalanceCompteModel> balances = await BalanceCompteApi().getAllData();
    // UserModel userModel = await AuthApi().getUserId();

    var data = balances
        // .where((element) =>
        //     element.approbationDG == "Approved" &&
        //         element.approbationDD == "Approved" ||
        //     element.signature == userModel.matricule)
        .toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'title': PlutoCell(value: item.title),
            'signature': PlutoCell(value: item.signature),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created)),
            'approbationDG': PlutoCell(value: item.approbationDG),
            'approbationDD': PlutoCell(value: item.approbationDD)
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
