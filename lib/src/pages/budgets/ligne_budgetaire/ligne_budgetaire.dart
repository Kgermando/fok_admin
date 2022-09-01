import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class LigneBudgetaire extends StatefulWidget {
  const LigneBudgetaire({Key? key, required this.departementBudgetModel})
      : super(key: key);
  final DepartementBudgetModel departementBudgetModel;

  @override
  State<LigneBudgetaire> createState() => _LigneBudgetaireState();
}

class _LigneBudgetaireState extends State<LigneBudgetaire> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  int? id;

  @override
  initState() {
    agentsColumn();
    agentsRow();
    super.initState();
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
          Navigator.pushNamed(context, BudgetRoutes.budgetLignebudgetaireDetail,
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
              const TitleWidget(title: 'Lignes budgetaires'),
              IconButton(
                  tooltip: 'Rafraichir',
                  onPressed: () {
                    Navigator.pushNamed(
                        context, BudgetRoutes.budgetBudgetPrevisionel);
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
              } else if (column.field == 'nomLigneBudgetaire') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'departement') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'periodeBudget') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'uniteChoisie') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'nombreUnite') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'coutUnitaire') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'coutTotal') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'caisse') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'banque') {
                return resolver<ClassFilterImplemented>() as PlutoFilterType;
              } else if (column.field == 'finExterieur') {
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
        title: 'Ligne Budgetaire',
        field: 'nomLigneBudgetaire',
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
        title: 'Département',
        field: 'departement',
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
        title: 'Date de cloture',
        field: 'periodeBudget',
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
        title: 'Unité',
        field: 'uniteChoisie',
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
        title: 'Nombre d\'Unité',
        field: 'nombreUnite',
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
        title: 'Coût Unitaire',
        field: 'coutUnitaire',
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
        title: 'Coût Total',
        field: 'coutTotal',
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
        title: 'Caisse',
        field: 'caisse',
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
        title: 'Banque',
        field: 'banque',
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
        title: 'Reste à trouver',
        field: 'finExterieur',
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
        type: PlutoColumnType.date(),
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
    List<LigneBudgetaireModel?> dataList =
        await LIgneBudgetaireApi().getAllData();
    var data = dataList
        .where((element) =>
            element!.departement == widget.departementBudgetModel.departement &&
            element.periodeBudgetDebut.microsecondsSinceEpoch ==
                widget
                    .departementBudgetModel.periodeDebut.microsecondsSinceEpoch)
        .toList();

    if (!mounted) return;
    setState(() {
      for (var item in data) {
        rows.add(PlutoRow(cells: {
          'id': PlutoCell(value: item!.id),
          'nomLigneBudgetaire': PlutoCell(value: item.nomLigneBudgetaire),
          'departement': PlutoCell(value: item.departement),
          'periodeBudget': PlutoCell(
              value: DateFormat("dd-MM-yyyy").format(item.periodeBudgetDebut)),
          'uniteChoisie': PlutoCell(value: item.uniteChoisie),
          'nombreUnite': PlutoCell(value: item.nombreUnite),
          'coutUnitaire': PlutoCell(value: item.coutUnitaire),
          'coutTotal': PlutoCell(
              value:
                  "${NumberFormat.decimalPattern('fr').format(double.parse(item.coutTotal))} \$"),
          'caisse': PlutoCell(
              value:
                  "${NumberFormat.decimalPattern('fr').format(double.parse(item.caisse))} \$"),
          'banque': PlutoCell(
              value:
                  "${NumberFormat.decimalPattern('fr').format(double.parse(item.banque))} \$"),
          'finExterieur': PlutoCell(
              value:
                  "${NumberFormat.decimalPattern('fr').format(double.parse(item.finExterieur))} \$"),
          'created': PlutoCell(
              value: DateFormat("dd-MM-yyyy HH:mm").format(item.created))
        }));
        stateManager!.resetCurrentState();
      }
    });
  }
}
