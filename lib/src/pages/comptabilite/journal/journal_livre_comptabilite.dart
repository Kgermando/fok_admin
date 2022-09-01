import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_livre_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_livre_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/table_journal_livre.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalLivreComptabilite extends StatefulWidget {
  const JournalLivreComptabilite({Key? key}) : super(key: key);

  @override
  State<JournalLivreComptabilite> createState() =>
      _JournalLivreComptabiliteState();
}

class _JournalLivreComptabiliteState extends State<JournalLivreComptabilite> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  DateTimeRange? dateRange;
  TextEditingController intituleController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    intituleController.dispose();

    super.dispose();
  }

  String signature = "";
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton.extended(
            tooltip: "Nouvel Journal",
            icon: const Icon(Icons.add),
            label: const Text("Add Journal"),
            onPressed: () {
              newjournalDialog();
            }),
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
                      const Expanded(child: TableJournalLivre())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  newjournalDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          final formKey = GlobalKey<FormState>();
          bool isLoading = false;
          String getPlageDate() {
            if (dateRange == null) {
              return 'Date de Debut et Fin';
            } else {
              return '${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}';
            }
          }

          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('New document', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 200,
                  width: 300,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: formKey,
                          child: Column(
                            children: [
                              intituleWidget(),
                              Container(
                                margin: const EdgeInsets.only(bottom: p20),
                                child: ButtonWidget(
                                  text: getPlageDate(),
                                  onClicked: () => setState(() {
                                    pickDateRange(context);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }),
                                ),
                              )
                            ],
                          ))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    isLoading = true;
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      submit().then((value) => isLoading = false);
                      form.reset();
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget intituleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: intituleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Libelé',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 20),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }

  Future<void> submit() async {
    final journalLivre = JournalLivreModel(
        intitule: intituleController.text,
        debut: dateRange!.start,
        fin: dateRange!.end,
        signature: signature,
        created: DateTime.now(),
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await JournalLivreApi().insertData(journalLivre).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Créé avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
