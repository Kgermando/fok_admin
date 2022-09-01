import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchGrandLivre extends StatefulWidget {
  const SearchGrandLivre({Key? key, required this.search}) : super(key: key);
  final List<JournalModel> search;

  @override
  State<SearchGrandLivre> createState() => _SearchGrandLivreState();
}

class _SearchGrandLivreState extends State<SearchGrandLivre> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  EasyTableModel<JournalModel>? _model;

  @override
  void initState() {
    List<JournalModel> rows =
        List.generate(widget.search.length, (index) => widget.search[index]);
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
    var journal = widget.search.map((e) => e.compte).first;
    var compteSplit = journal.split('_');
    var compte = compteSplit.first;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!Responsive.isMobile(context))
                            SizedBox(
                              width: p20,
                              child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back)),
                            ),
                          if (!Responsive.isMobile(context))
                            const SizedBox(width: p10),
                          Expanded(
                            child: CustomAppbar(
                                title: 'Comptabilités',
                                controllerMenu: () =>
                                    _key.currentState!.openDrawer()),
                          ),
                        ],
                      ),
                      Card(
                        child: Container(
                            padding: const EdgeInsets.all(p20),
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                    "Résultats pour le compte <<$compte>>",
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: mainColor)),
                                const SizedBox(height: p20),
                                Expanded(
                                    child: EasyTable<JournalModel>(_model,
                                        multiSort: true)),
                                totalWidget()
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget totalWidget() {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    double totalDebit = 0.0;
    double totalCredit = 0.0;
    for (var element in widget.search) {
      totalDebit += double.parse(element.montantDebit);
    }
    for (var element in widget.search) {
      totalCredit += double.parse(element.montantCredit);
    }
    return Padding(
      padding: const EdgeInsets.all(p20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Responsive.isMobile(context)
                ? Column(
                    children: [
                      Text("Total débit :",
                          style: headlineMedium!.copyWith(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                      Text(
                          "${NumberFormat.decimalPattern('fr').format(totalDebit)} \$",
                          style: headlineMedium.copyWith(color: Colors.red))
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text("Total débit :",
                              style: headlineMedium!.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 2,
                          child: Text(
                              "${NumberFormat.decimalPattern('fr').format(totalDebit)} \$",
                              style:
                                  headlineMedium.copyWith(color: Colors.red))),
                    ],
                  ),
          ),
          Expanded(
            child: Responsive.isMobile(context)
                ? Column(
                    children: [
                      Text("Total crédit :",
                          style: headlineMedium.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                      Text(
                          "${NumberFormat.decimalPattern('fr').format(totalCredit)} \$",
                          style: headlineMedium.copyWith(color: Colors.orange))
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text("Total crédit :",
                              style: headlineMedium.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 2,
                          child: Text(
                              "${NumberFormat.decimalPattern('fr').format(totalCredit)} \$",
                              style: headlineMedium.copyWith(
                                  color: Colors.orange))),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
