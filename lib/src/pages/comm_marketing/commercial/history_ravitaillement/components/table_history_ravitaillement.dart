import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/history_rabitaillement_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/history_ravitaillement_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/history_ravitaillement/components/history_ravitaillement_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableHistoryRavitaillement extends StatefulWidget {
  const TableHistoryRavitaillement({Key? key}) : super(key: key);

  @override
  State<TableHistoryRavitaillement> createState() =>
      _TableHistoryRavitaillementState();
}

class _TableHistoryRavitaillementState
    extends State<TableHistoryRavitaillement> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

  List<HistoryRavitaillementModel> dataList = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    List<HistoryRavitaillementModel> historyRavitaillements =
        await HistoryRavitaillementApi().getAllData();
    setState(() {
      dataList = historyRavitaillements
          .where((element) => element.succursale == userModel.succursale)
          .toSet()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
        // final dataList = tapEvent.row!.cells.values;
        // final idPlutoRow = dataList.elementAt(0);

        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => DetailProdModel(id: idPlutoRow.value)));
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
            const TitleWidget(title: "Historique de Ravitaillements"),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          ComMarketingRoutes.comMarketingHistoryRavitaillement);
                    },
                    icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                PrintWidget(onPressed: () {
                  HistoriqueRavitaillementXlsx().exportToExcel(dataList);
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
            } else if (column.field == 'idProduct') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'quantity') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'quantityAchat') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'priceAchatUnit') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'prixVenteUnit') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'margeBen') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'tva') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'qtyRavitailler') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'succursale') {
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
        title: 'Id Produit',
        field: 'idProduct',
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
        title: 'Quantité',
        field: 'quantity',
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
        title: 'Quantité d\'Achat',
        field: 'quantityAchat',
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
        title: 'Prix d\'Achat Unitaire \$',
        field: 'priceAchatUnit',
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
        title: 'Prix de vente Unitaire \$',
        field: 'prixVenteUnit',
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
        title: 'Marge Benefiaire',
        field: 'margeBen',
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
        title: 'TVA %',
        field: 'tva',
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
        title: 'Quantité Ravitailler',
        field: 'qtyRavitailler',
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
    UserModel userModel = await AuthApi().getUserId();
    List<HistoryRavitaillementModel> historyRavitaillements =
        await HistoryRavitaillementApi().getAllData();
    var data = historyRavitaillements
        .where((element) =>
            element.succursale == userModel.succursale ||
            int.parse(userModel.role) <= 2)
        .toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'idProduct': PlutoCell(value: item.idProduct),
            'quantity': PlutoCell(value: '${item.quantity} ${item.unite}'),
            'quantityAchat': PlutoCell(value: item.quantityAchat),
            'priceAchatUnit': PlutoCell(value: item.priceAchatUnit),
            'prixVenteUnit': PlutoCell(value: item.prixVenteUnit),
            'margeBen': PlutoCell(value: item.margeBen),
            'tva': PlutoCell(value: item.tva),
            'qtyRavitailler': PlutoCell(value: item.qtyRavitailler),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created))
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
