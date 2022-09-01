import 'dart:async';

import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/agenda_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/agenda_card_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class AgendaMarketing extends StatefulWidget {
  const AgendaMarketing({Key? key}) : super(key: key);

  @override
  State<AgendaMarketing> createState() => _AgendaMarketingState();
}

class _AgendaMarketingState extends State<AgendaMarketing> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late Future<List<AgendaModel>> dataFuture;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateRappelController = TextEditingController();

  @override
  initState() {
    getData();
    dataFuture = getDataFuture();

    super.initState();
  }

  @override
  dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateRappelController.dispose();
    super.dispose();
  }

  String user = '';
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    if (mounted) {
      setState(() {
        user = userModel.matricule;
      });
    }
  }

  Future<List<AgendaModel>> getDataFuture() async {
    var agendaList = await AgendaApi().getAllData();
    return agendaList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Nouvel agenda',
            child: const Icon(Icons.add),
            onPressed: () {
              newFicheDialog();
              // Navigator.of(context)
              //     .pushNamed(ComMarketingRoutes.comMarketingAgendaAdd);
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
                              ? 'Commercial & Marketing'
                              : 'Comm. & Mark.',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(title: "Agenda"),
                                Padding(
                                  padding: const EdgeInsets.all(p8),
                                  child: IconButton(
                                      color: Colors.green.shade700,
                                      tooltip: "Rafraichir la page",
                                      onPressed: () {
                                        setState(() {
                                          dataFuture = getDataFuture();
                                        });
                                      },
                                      icon: const Icon(Icons.refresh)),
                                )
                              ]),
                          Expanded(
                              child: FutureBuilder<List<AgendaModel>>(
                                  future: dataFuture,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<AgendaModel>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      List<AgendaModel>? agendaList = snapshot
                                          .data!
                                          .where((element) =>
                                              element.signature == user)
                                          .toList();
                                      return buildAgenda(agendaList);
                                    } else {
                                      return Center(child: loading());
                                    }
                                  })),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildAgenda(List<AgendaModel> agendaList) {
    return (agendaList.isEmpty)
        ? const Center(child: Text("Ajouter quelque chose... 😊!"))
        : StaggeredGrid.count(
            crossAxisCount: Responsive.isDesktop(context) ? 6 : 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: List.generate(agendaList.length, (index) {
              final agenda = agendaList[index];
              final color = _lightColors[index % _lightColors.length];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      ComMarketingRoutes.comMarketingAgendaDetail,
                      arguments:
                          AgendaColor(agendaModel: agenda, color: color));
                },
                child: AgendaCardWidget(
                    agendaModel: agenda, index: index, color: color),
              );
            }),
          );
  }

  newFicheDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: Text('Ajout Rappel', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 450,
                  width: 500,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: p20),
                              dateRappelWidget(),
                              const SizedBox(height: p16),
                              buildTitle(),
                              const SizedBox(height: p16),
                              buildDescription(),
                              const SizedBox(
                                height: p20,
                              ),
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
                      setState(() {
                        isLoading = true;
                      });
                      submit().then((value) {
                        isLoading = false;
                      });
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

  Widget buildTitle() {
    return TextFormField(
      maxLength: 50,
      controller: titleController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Objet...',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Ce champs est obligatoire';
        } else {
          return null;
        }
      },
    );
  }

  Widget dateRappelWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.date_range),
            border: UnderlineInputBorder(),
            labelText: 'Rappel',
          ),
          controller: dateRappelController,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget buildDescription() {
    return TextFormField(
      maxLines: 5,
      keyboardAppearance: Brightness.dark,
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        labelText: 'Ecrivez quelque chose...',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Ce champs est obligatoire';
        } else {
          return null;
        }
      },
    );
  }

  Future<void> submit() async {
    final agendaModel = AgendaModel(
        title: titleController.text,
        description: descriptionController.text,
        dateRappel: DateTime.parse(dateRappelController.text),
        signature: user,
        created: DateTime.now());
    await AgendaApi().insertData(agendaModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregister avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
