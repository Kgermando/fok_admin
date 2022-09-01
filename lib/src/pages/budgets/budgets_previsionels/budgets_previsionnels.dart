import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/components/table_departement_budget.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/button_widget.dart';
import 'package:intl/intl.dart';

class BudgetsPrevisionnels extends StatefulWidget {
  const BudgetsPrevisionnels({Key? key}) : super(key: key);

  @override
  State<BudgetsPrevisionnels> createState() => _BudgetsPrevisionnelsState();
}

class _BudgetsPrevisionnelsState extends State<BudgetsPrevisionnels> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final List<String> departementList = Dropdown().departement;
  DateTimeRange? dateRange;

  String? departement;
  TextEditingController titleController = TextEditingController();

  String getPlageDate() {
    if (dateRange == null) {
      return 'Date de Debut et Fin';
    } else {
      return '${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}';
    }
  }

  @override
  initState() {
    getData();
    getPlageDate();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  String? signature;
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
        floatingActionButton: FloatingActionButton(
            tooltip: "Crée le budget",
            child: const Icon(Icons.add),
            onPressed: () {
              newFicheDialog();
              // Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context) => const AddBudgetPrevionel()));
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
                          title: Responsive.isDesktop(context)
                              ? 'Budgets previsionels'
                              : 'B. previsionels',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableDepartementBudget())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  newFicheDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Génerer le Budget previsionnel'),
              content: SizedBox(
                  height: 300,
                  width: 500,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              titleWidget(),
                              departmentWidget(),
                              dateDebutEtFinWidget(),
                            ],
                          ))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      submit();
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

  Widget titleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: titleController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Titre',
          ),
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

  Widget departmentWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Département',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: departement,
        isExpanded: true,
        items: departementList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select departement" : null,
        onChanged: (value) {
          setState(() {
            departement = value!;
          });
        },
      ),
    );
  }

  Widget dateDebutEtFinWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: ButtonWidget(
        text: getPlageDate(),
        onClicked: () => setState(() {
          pickDateRange(context);
          FocusScope.of(context).requestFocus(FocusNode());
        }),
      ),
    );
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
    final departementBudgetModel = DepartementBudgetModel(
        title: titleController.text,
        departement: departement.toString(),
        periodeDebut: dateRange!.start,
        periodeFin: dateRange!.end,
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        isSubmit: 'false',
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');

    await DepeartementBudgetApi()
        .insertData(departementBudgetModel)
        .then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Crée avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
