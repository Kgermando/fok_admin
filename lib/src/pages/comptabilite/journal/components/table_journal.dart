import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TableJournal extends StatefulWidget {
  const TableJournal({Key? key, required this.itemList}) : super(key: key);
  final List<JournalModel> itemList;

  @override
  State<TableJournal> createState() => _TableJournalState();
}

class _TableJournalState extends State<TableJournal> {
  EasyTableModel<JournalModel>? _model;

  @override
  void initState() {
    List<JournalModel> rows = List.generate(
        widget.itemList.length, (index) => widget.itemList[index]);
    _model = EasyTableModel<JournalModel>(rows: rows, columns: [
      EasyTableColumn(
        name: 'Date',
        width: 200,
        stringValue: (row) =>
            DateFormat("dd-MM-yyyy HH:mm").format(row.created),
      ),
      EasyTableColumn(
          name: 'N° Operation',
          width: 150,
          stringValue: (row) => row.numeroOperation),
      EasyTableColumn(
          name: 'Libele', width: 300, stringValue: (row) => row.libele),
      EasyTableColumn(
          name: 'Compte',
          width: 100,
          stringValue: (row) {
            var compteSplit = row.compte.split('_');
            var compte = compteSplit.first;
            return compte;
          }),
      EasyTableColumn(
          name: 'Debit',
          width: 100,
          stringValue: (row) => (row.montantDebit == "0")
              ? "-"
              : "${NumberFormat.decimalPattern('fr').format(double.parse(row.montantDebit))} \$"),
      EasyTableColumn(
          name: 'Credit',
          width: 100,
          stringValue: (row) => (row.montantCredit == "0")
              ? "-"
              : "${NumberFormat.decimalPattern('fr').format(double.parse(row.montantCredit))} \$"),
      EasyTableColumn(
          name: 'TVA', width: 100, stringValue: (row) => "${row.tva} %"),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(p10),
      child: EasyTable<JournalModel>(_model, multiSort: true),
    ));
  }
}
