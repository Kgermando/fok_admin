import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/campaign/campaign_xlxs.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableCampaign extends StatefulWidget {
  const TableCampaign({Key? key}) : super(key: key);

  @override
  State<TableCampaign> createState() => _TableCampaignState();
}

class _TableCampaignState extends State<TableCampaign> {
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

  List<CampaignModel> dataList = [];
  Future<void> getData() async {
    List<CampaignModel> campaigns = await CampaignApi().getAllData();
    setState(() {
      dataList = campaigns.toList();
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
            context, ComMarketingRoutes.comMarketingCampaignDetail,
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
            const TitleWidget(title: "Campagnes"),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ComMarketingRoutes.comMarketingCampaign);
                    },
                    icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                PrintWidget(onPressed: () {
                  CampagneXlsx().exportToExcel(dataList);
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
            } else if (column.field == 'typeProduit') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'dateDebutEtFin') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'coutCampaign') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'lieuCible') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'promotion') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'objectifs') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'created') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationDG') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationDD') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationBudget') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'approbationFin') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            }
            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          },
        ),
      ),
      rowColorCallback: (rowColorContext) {
        if (rowColorContext.row.cells.entries
                    .elementAt(8)
                    .value
                    .value ==
                'Unapproved' ||
            rowColorContext.row.cells.entries.elementAt(9).value.value ==
                'Unapproved' ||
            rowColorContext.row.cells.entries.elementAt(10).value.value ==
                'Unapproved' ||
            rowColorContext.row.cells.entries.elementAt(11).value.value ==
                'Unapproved') {
          return Colors.red.shade700;
        } else if (rowColorContext.row.cells.entries.elementAt(8).value.value ==
                'Approved' &&
            rowColorContext.row.cells.entries.elementAt(9).value.value ==
                'Approved' &&
            rowColorContext.row.cells.entries.elementAt(10).value.value ==
                'Approved' &&
            rowColorContext.row.cells.entries.elementAt(11).value.value ==
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
        title: 'Type Produit',
        field: 'typeProduit',
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
        title: 'Date Debut Et Fin',
        field: 'dateDebutEtFin',
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
        title: 'Coût de la Campagne',
        field: 'coutCampaign',
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
        title: 'Lieu Ciblé',
        field: 'lieuCible',
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
        title: 'Promotion',
        field: 'promotion',
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
        title: 'Objectifs',
        field: 'objectifs',
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
      PlutoColumn(
        readOnly: true,
        title: 'Approbation Budget',
        field: 'approbationBudget',
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
        title: 'Approbation Fin',
        field: 'approbationFin',
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
    List<CampaignModel> campaigns = await CampaignApi().getAllData();
    // Uniquement ceux qui ont déjà été approuvé
    var data = campaigns.toList();

    if (mounted) {
      setState(() {
        for (var item in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: item.id),
            'typeProduit': PlutoCell(value: item.typeProduit),
            'dateDebutEtFin': PlutoCell(value: item.dateDebutEtFin),
            'coutCampaign': PlutoCell(value: "${item.coutCampaign} \$"),
            'lieuCible': PlutoCell(value: item.lieuCible),
            'promotion': PlutoCell(value: item.promotion),
            'objectifs': PlutoCell(value: item.objectifs),
            'created': PlutoCell(
                value: DateFormat("dd-MM-yy H:mm").format(item.created)),
            'approbationDG': PlutoCell(value: item.approbationDG),
            'approbationDD': PlutoCell(value: item.approbationDD),
            'approbationBudget': PlutoCell(value: item.approbationBudget),
            'approbationFin': PlutoCell(value: item.approbationFin)
          }));
        }
        stateManager!.resetCurrentState();
      });
    }
  }
}
