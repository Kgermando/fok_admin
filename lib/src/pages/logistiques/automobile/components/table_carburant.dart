import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/models/logistiques/carburant_model.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/carburant_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCarburant extends StatefulWidget {
  const TableCarburant({Key? key}) : super(key: key);

  @override
  State<TableCarburant> createState() => _TableCarburantState();
}

class _TableCarburantState extends State<TableCarburant> {
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

  List<CarburantModel> dataList = [];

  Future<void> getData() async {
    List<CarburantModel> carburants = await CarburantApi().getAllData();
    setState(() {
      dataList = carburants.toList();
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
        Navigator.pushNamed(context, LogistiqueRoutes.logCarburantAutoDetail,
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
            const TitleWidget(title: "Carburants"),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, LogistiqueRoutes.logCarburantAuto);
                    },
                    icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                PrintWidget(onPressed: () {
                  CarburantXlsx().exportToExcel(dataList);
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
            } else if (column.field == 'operationEntreSortie') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'typeCaburant') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'fournisseur') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'nomeroFactureAchat') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'prixAchatParLitre') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'qtyAchat') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'nomReceptioniste') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'numeroPlaque') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'dateHeureSortieAnguin') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'created') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationDD') {
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
        title: 'Tyep d\'Opération',
        field: 'operationEntreSortie',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 80,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Type Caburant',
        field: 'typeCaburant',
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
        title: 'Fournisseur',
        field: 'fournisseur',
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
        title: 'Numero Facture Achat',
        field: 'nomeroFactureAchat',
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
        title: 'Prix Achat Par Litre',
        field: 'prixAchatParLitre',
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
        title: 'Quantité',
        field: 'qtyAchat',
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
        title: 'Nom du receptioniste',
        field: 'nomReceptioniste',
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
        title: 'Numero Plaque',
        field: 'numeroPlaque',
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
        title: 'Date Entrer / Sortie',
        field: 'dateHeureSortieAnguin',
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
    List<CarburantModel?> dataList = await CarburantApi().getAllData();
    // UserModel userModel = await AuthApi().getUserId();
    var data = dataList
        // .where((element) =>
        // element!.approbationDD == "Approved" ||
        // element.signature == userModel.matricule)
        .toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item!.id),
            'operationEntreSortie': PlutoCell(value: item.operationEntreSortie),
            'typeCaburant': PlutoCell(value: item.typeCaburant),
            'fournisseur': PlutoCell(value: item.fournisseur),
            'nomeroFactureAchat': PlutoCell(value: item.nomeroFactureAchat),
            'prixAchatParLitre':
                PlutoCell(value: "${item.prixAchatParLitre} \$"),
            'qtyAchat': PlutoCell(value: "${item.prixAchatParLitre} L"),
            'nomReceptioniste': PlutoCell(value: item.nomReceptioniste),
            'numeroPlaque': PlutoCell(value: item.numeroPlaque),
            'dateHeureSortieAnguin': PlutoCell(
                value:
                    DateFormat("dd-MM-yy").format(item.dateHeureSortieAnguin)),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy HH:mm").format(item.created)),
            'approbationDD': PlutoCell(value: item.approbationDD)
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
