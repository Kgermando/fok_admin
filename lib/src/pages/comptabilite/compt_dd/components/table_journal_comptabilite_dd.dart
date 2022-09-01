import 'dart:async';

import 'package:fokad_admin/src/api/comptabilite/journal_livre_api.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_livre_model.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/journal_xksx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableJournalComptabiliteDD extends StatefulWidget {
  const TableJournalComptabiliteDD({Key? key}) : super(key: key);

  @override
  State<TableJournalComptabiliteDD> createState() =>
      _TableJournalComptabiliteDDState();
}

class _TableJournalComptabiliteDDState
    extends State<TableJournalComptabiliteDD> {
  Timer? timer;
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

  List<JournalLivreModel> dataList = [];
  Future<void> getData() async {
    List<JournalLivreModel> journals = await JournalLivreApi().getAllData();
    setState(() {
      dataList =
          journals.where((element) => element.approbationDD == "-").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
          final dataId = tapEvent.row!.cells.values;
          final idPlutoRow = dataId.elementAt(0);

          Navigator.pushNamed(
              context, ComptabiliteRoutes.comptabiliteJournalDetail,
              arguments: idPlutoRow.value);
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.setShowColumnFilter(true);
        },
        createHeader: (PlutoGridStateManager header) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TitleWidget(title: "Journals"),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            ComptabiliteRoutes.comptabiliteJournalLivre);
                      },
                      icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                  PrintWidget(onPressed: () {
                    JournalXlsx().exportToExcel(dataList);
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
              } else if (column.field == 'intitule') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'debut') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'fin') {
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
          if (rowColorContext.row.cells.entries.elementAt(6).value.value ==
                  'Unapproved' ||
              rowColorContext.row.cells.entries.elementAt(7).value.value ==
                  'Unapproved') {
            return Colors.red.shade700;
          } else if (rowColorContext.row.cells.entries
                      .elementAt(6)
                      .value
                      .value ==
                  'Approved' &&
              rowColorContext.row.cells.entries.elementAt(7).value.value ==
                  'Approved') {
            return Colors.green.shade700;
          }
          return Colors.white;
        },
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
        width: 50,
        minWidth: 50,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Intitule',
        field: 'intitule',
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
        title: 'Date de debut',
        field: 'debut',
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
        title: 'Date de fin',
        field: 'fin',
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
    List<JournalLivreModel> journals = await JournalLivreApi().getAllData();
    var data =
        journals.where((element) => element.approbationDD == "-").toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'intitule': PlutoCell(value: item.intitule),
            'debut':
                PlutoCell(value: DateFormat("dd-MM-yyyy").format(item.debut)),
            'fin': PlutoCell(value: DateFormat("dd-MM-yyyy").format(item.fin)),
            'signature': PlutoCell(value: item.signature),
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
