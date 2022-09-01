import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/finances/creance_dette_api.dart';
import 'package:fokad_admin/src/models/finances/creance_dette_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCreanceDette extends StatefulWidget {
  const TableCreanceDette(
      {Key? key, required this.creanceDette, required this.createdRef})
      : super(key: key);
  final String creanceDette;
  final DateTime createdRef;

  @override
  State<TableCreanceDette> createState() => _TableCreanceDetteState();
}

class _TableCreanceDetteState extends State<TableCreanceDette> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    agentsColumn();
    agentsRow();
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleWidget(
                title: (widget.creanceDette == "creances")
                    ? 'Paiement'
                    : "Remboursement"),
            (widget.creanceDette == "creances")
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, FinanceRoutes.transactionsCreances);
                    },
                    icon: Icon(Icons.refresh, color: Colors.green.shade700))
                : IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, FinanceRoutes.transactionsDettes);
                    },
                    icon: Icon(Icons.refresh, color: Colors.green.shade700)),
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
            } else if (column.field == 'numeroTache') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'agent') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'jalon') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'created') {
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
        title: 'Nom Complet',
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
        title: 'Pièce Justificative',
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
    List<CreanceDetteModel> creanceDettes =
        await CreanceDetteApi().getAllData();
    var data = creanceDettes.where((element) =>
        element.creanceDette == widget.creanceDette &&
        element.reference == widget.createdRef);

    if (mounted) {
      setState(() {
        for (var i = 1; i < data.length; i++) {
          for (var item in data) {
            rows.add(PlutoRow(cells: {
              'id': PlutoCell(value: i),
              'nomComplet': PlutoCell(value: item.nomComplet),
              'pieceJustificative': PlutoCell(value: item.pieceJustificative),
              'libelle': PlutoCell(value: item.libelle),
              'montant': PlutoCell(
                  value:
                      "${NumberFormat.decimalPattern('fr').format(double.parse(item.montant))} \$"),
              'signature': PlutoCell(value: item.signature),
              'created': PlutoCell(
                  value: DateFormat("dd-MM-yyy HH:mm").format(item.created))
            }));
            stateManager!.resetCurrentState();
          }
        }
      });
    }
  }
}
