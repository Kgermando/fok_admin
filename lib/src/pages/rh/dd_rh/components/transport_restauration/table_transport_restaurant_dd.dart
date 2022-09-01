import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/components/transport_restauration_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableTansportRestaurantDD extends StatefulWidget {
  const TableTansportRestaurantDD({Key? key}) : super(key: key);

  @override
  State<TableTansportRestaurantDD> createState() =>
      _TableTansportRestaurantDDState();
}

class _TableTansportRestaurantDDState extends State<TableTansportRestaurantDD> {
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

  List<TransportRestaurationModel> dataList = [];

  Future<void> getData() async {
    var data = await TransportRestaurationApi().getAllData();
    if (mounted) {
      setState(() {
        dataList =
            data.where((element) => element.approbationDD == '-').toList();
      });
    }
  }

  void handleKeyboard(PlutoKeyManagerEvent event) {
    // Specify the desired shortcut key.
    if (event.isKeyDownEvent && event.isCtrlC) {
      agentsRow();
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
          Navigator.pushNamed(context, RhRoutes.rhTransportRestDetail,
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
              const TitleWidget(title: "Transports & Restaurations"),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RhRoutes.rhTransportRest);
                      },
                      icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                  PrintWidget(onPressed: () {
                    TransportRestXlsx().exportToExcel(dataList);
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
              ClassFilterImplemented(),
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'id') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'title') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'observation') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'signature') {
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
        title: 'Intitlé',
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
        title: 'Signature',
        field: 'signature',
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
    var transRests = await TransportRestaurationApi().getAllData();

    // Uniquement ceux qui ont déjà été approuvé
    var data = transRests
        .where((element) =>
            element.approbationDD == '-' && element.isSubmit == 'true')
        .toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'title': PlutoCell(value: item.title),
            'observation': PlutoCell(
                value: (item.observation == 'true') ? "Payé" : "Non payé"),
            'signature': PlutoCell(value: item.signature),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
          }));
          stateManager!.resetCurrentState();
          stateManager!.notifyListeners();
          // stateManager!.isPaginated;
          //
        }
      });
    }
  }
}
