import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_livre_api.dart';
import 'package:fokad_admin/src/models/comptabilites/grand_livre_model.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_livre_model.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

class GrandLivreComptabilite extends StatefulWidget {
  const GrandLivreComptabilite({Key? key}) : super(key: key);

  @override
  State<GrandLivreComptabilite> createState() => _GrandLivreComptabiliteState();
}

class _GrandLivreComptabiliteState extends State<GrandLivreComptabilite> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  JournalLivreModel? reference;
  // int? reference;
  TextEditingController compteController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    compteController.dispose();
    super.dispose();
  }

  List<JournalLivreModel> journalLivreList = [];
  Future<void> getData() async {
    var journalLivres = await JournalLivreApi().getAllData();
    setState(() {
      journalLivreList = journalLivres;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      CustomAppbar(
                          title: 'Comptabilités',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                        child: FutureBuilder<List<JournalModel>>(
                            future: JournalApi().getAllData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<JournalModel>> snapshot) {
                              if (snapshot.hasData) {
                                List<JournalModel>? itemList = snapshot.data;
                                return pageView(itemList!);
                              } else {
                                return Center(child: loadingMega());
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget pageView(List<JournalModel> data) {
    return Container(
      // width: width,
      padding: const EdgeInsets.all(p20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    color: Colors.green,
                    tooltip: "Actualiser la page",
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ComptabiliteRoutes.comptabiliteGrandLivre);
                    },
                    icon: const Icon(Icons.refresh)),
              ],
            ),
            const SizedBox(height: p10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.book, size: p50, color: Colors.red),
                        TitleWidget(title: "Grand Livre"),
                      ],
                    ),
                    const SizedBox(height: p20),
                    Responsive.isMobile(context)
                        ? Column(children: [
                            compteWidget(data),
                            livreWidget(),
                            buttonWidget(data)
                          ])
                        : Row(children: [
                            SizedBox(width: 300.0, child: compteWidget(data)),
                            const SizedBox(width: p10),
                            SizedBox(width: 250.0, child: livreWidget()),
                            const SizedBox(width: p10),
                            SizedBox(
                                width: 150.0,
                                height: 70,
                                child: buttonWidget(data))
                          ]),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget livreWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<JournalLivreModel>(
        decoration: InputDecoration(
          labelText: 'Livre',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: reference,
        isExpanded: true,
        items: journalLivreList
            .map((JournalLivreModel? value) {
              return DropdownMenuItem<JournalLivreModel>(
                value: value,
                child: Text(value!.intitule),
              );
            })
            .toSet()
            .toList(),
        validator: (value) => value == null ? "Select Livre" : null,
        onChanged: (value) {
          setState(() {
            reference = value;
          });
        },
      ),
    );
  }

  Widget compteWidget(List<JournalModel> data) {
    List<String> suggestionList = data.map((e) => e.compte).toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          controller: compteController,
          decoration: InputDecoration(
            labelText: 'Compte',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget buttonWidget(List<JournalModel> data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: ElevatedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            primary: mainColor,
          ),
          onPressed: () {
            isLoading = true;
            final form = formKey.currentState!;
            if (form.validate()) {
              searchKey(data);
              form.reset();
            }
          },
          icon: const Icon(Icons.search, color: Colors.white),
          label: Text("Recherche",
              style: bodyMedium!.copyWith(color: Colors.white))),
    );
  }

  void searchKey(List<JournalModel> data) {
    final livre = GrandLivreModel(
        reference: reference!.id!, compte: compteController.text);
    final search = data
        .where((element) =>
            element.compte == livre.compte &&
                element.reference == livre.reference ||
            element.compte == compteController.text)
        .toList();
    Navigator.pushNamed(
        context, ComptabiliteRoutes.comptabiliteGrandLivreSearch,
        arguments: search);
  }
}
