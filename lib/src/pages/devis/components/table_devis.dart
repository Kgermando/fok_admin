import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableDevis extends StatefulWidget {
  const TableDevis({Key? key, required this.departement}) : super(key: key);
  final String departement;

  @override
  State<TableDevis> createState() => _TableDevisState();
}

class _TableDevisState extends State<TableDevis> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  initState() {
    agentsColumn();
    getData();
    agentsRow();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? matricule;
  String? departement;
  String? servicesAffectation;
  String? fonctionOccupe;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    if (mounted) {
      setState(() {
        matricule = userModel.matricule;
        departement = userModel.departement;
        servicesAffectation = userModel.servicesAffectation;
        fonctionOccupe = userModel.fonctionOccupe;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
          final dataId = tapEvent.row!.cells.values;
          final idPlutoRow = dataId.elementAt(0);

          Navigator.pushNamed(context, DevisRoutes.devisDetail,
              arguments: idPlutoRow.value);
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager!.setShowColumnFilter(true);
          stateManager!.notifyListeners();
        },
        createHeader: (PlutoGridStateManager header) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [],
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
              } else if (column.field == 'title') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'priority') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              }
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            },
          ),
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
        title: 'Titre',
        field: 'title',
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
        title: 'Priorité',
        field: 'priority',
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
        width: 300,
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
        width: 300,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<DevisModel?> dataList = await DevisAPi().getAllData();
    //  List<DevisModel?> data = [];
    // var approbations = await ApprobationApi().getAllData();
    // for (var item in approbations) {
    //   data = dataList
    //       .where((element) =>
    //           element!.departement == userModel.departement &&
    //           userModel.fonctionOccupe == 'Directeur de departement' ||
    //           userModel.fonctionOccupe == 'Directeur de budget' ||
    //           userModel.fonctionOccupe == 'Directeur de finance' ||
    //           userModel.fonctionOccupe == 'Directeur de générale')
    //       .toList();
    // }

    if (mounted) {
      setState(() {
        for (var item in dataList) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'title': PlutoCell(value: item.title),
            'priority': PlutoCell(value: item.priority),
            'departement': PlutoCell(value: item.departement),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
