import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/finances/coupure_billet_api.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCoupureBillet extends StatefulWidget {
  const TableCoupureBillet({Key? key, required this.createdRef})
      : super(key: key);
  final int createdRef;

  @override
  State<TableCoupureBillet> createState() => _TableCoupureBilletState();
}

class _TableCoupureBilletState extends State<TableCoupureBillet> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  initState() {
    agentsRow();
    agentsColumn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.setShowColumnFilter(true);
        stateManager!.notifyListeners();
      },
      createHeader: (PlutoGridStateManager header) {
        return const TitleWidget(title: 'Coupure billets');
      },
      configuration: PlutoGridConfiguration(
        columnFilter: PlutoGridColumnFilterConfig(
          filters: const [
            ...FilterHelper.defaultFilters,
            // custom filter
            ClassFilterImplemented(),
          ],
          resolveDefaultColumnFilter: (column, resolver) {
            if (column.field == 'nombreBillet') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'coupureBillet') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            }
            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          },
        ),
      ),
    );
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'Nombre',
        field: 'nombreBillet',
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
        title: 'Coupure',
        field: 'coupureBillet',
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
    var coupureBillets = await CoupureBilletApi().getAllData();
    var data = coupureBillets
        .where((element) => element.reference == widget.createdRef)
        .toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'nombreBillet': PlutoCell(value: item.nombreBillet),
            'coupureBillet': PlutoCell(value: "${item.coupureBillet} \$")
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
