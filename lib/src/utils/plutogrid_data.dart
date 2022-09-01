import 'package:pluto_grid/pluto_grid.dart';

class PlutoGridData {
  static List<PlutoRow> rowsByColumns({
    required int length,
    required List<PlutoColumn> columns,
  }) {
    return List<int>.generate(length, (index) => index).map((_) {
      return rowByColumns(columns);
    }).toList();
  }

  static PlutoRow rowByColumns(List<PlutoColumn> columns) {
    final cells = <String, PlutoCell>{};

    for (var column in columns) {
      cells[column.field] = PlutoCell(
        value: column,
      );
    }

    return PlutoRow(cells: cells);
  }

 
}