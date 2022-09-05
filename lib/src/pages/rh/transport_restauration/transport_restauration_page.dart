import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/components/table_transport_restaurant.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class TransportRestaurationPage extends StatefulWidget {
  const TransportRestaurationPage({Key? key}) : super(key: key);

  @override
  State<TransportRestaurationPage> createState() =>
      _TransportRestaurationPageState();
}

class _TransportRestaurationPageState extends State<TransportRestaurationPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  String? matricule;

  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    setState(() {
      matricule = userModel.matricule;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              constraints: BoxConstraints(
                maxWidth: Responsive.isDesktop(context)
                    ? sized.width / 2
                    : sized.width,
              ),
              builder: (BuildContext context) {
                return Container(
                  height: Responsive.isDesktop(context)
                      ? sized.height / 2
                      : sized.height,
                  color: Colors.amber.shade100,
                  padding: const EdgeInsets.all(p20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const TitleWidget(title: "Créez la liste de paie"),
                        const SizedBox(
                          height: p20,
                        ),
                        titleWidget(),
                        const SizedBox(
                          height: p20,
                        ),
                        BtnWidget(
                            title: 'Crée maintenant',
                            press: () {
                              setState(() {
                                isLoading = true;
                              });
                              final form = _formKey.currentState!;
                              if (form.validate()) {
                                submit();
                                form.reset();
                              }
                            },
                            isLoading: isLoading)
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
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
                          title: (Responsive.isDesktop(context))
                              ? "Ressources Humaines"
                              : "RH",
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableTansportRestaurant())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget titleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Intitulé',
          ),
          keyboardType: TextInputType.text,
          maxLength: 30,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future submit() async {
    final transRest = TransportRestaurationModel(
        title: titleController.text,
        observation: 'true',
        signature: matricule.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        approbationDG: 'Approved',
        motifDG: '-',
        signatureDG: '-',
        approbationBudget: 'Approved',
        motifBudget: '-',
        signatureBudget: '-',
        approbationFin: 'Approved',
        motifFin: '-',
        signatureFin: '-',
        approbationDD: 'Approved',
        motifDD: '-',
        signatureDD: '-',
        ligneBudgetaire: '-',
        ressource: '-',
        isSubmit: 'false');
    await TransportRestaurationApi().insertData(transRest).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Crée avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
