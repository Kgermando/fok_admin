import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/agenda_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';

class UpdateAgenda extends StatefulWidget {
  const UpdateAgenda({Key? key, required this.agendaColor}) : super(key: key);
  final AgendaColor agendaColor;

  @override
  State<UpdateAgenda> createState() => _UpdateAgendaState();
}

class _UpdateAgendaState extends State<UpdateAgenda> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateRappelController = TextEditingController();

  @override
  void initState() {
    getData();
    setState(() {
      titleController =
          TextEditingController(text: widget.agendaColor.agendaModel.title);
      descriptionController = TextEditingController(
          text: widget.agendaColor.agendaModel.description);
      dateRappelController = TextEditingController(
          text: widget.agendaColor.agendaModel.dateRappel.toIso8601String());
    });
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateRappelController.dispose();
    super.dispose();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
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
                      Row(
                        children: [
                          if (!Responsive.isMobile(context))
                            SizedBox(
                              width: p20,
                              child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back)),
                            ),
                          const SizedBox(width: p10),
                          Expanded(
                            flex: 5,
                            child: CustomAppbar(
                                title: Responsive.isDesktop(context)
                                    ? 'Commercial & Marketing'
                                    : 'Comm. & Mark.',
                                controllerMenu: () =>
                                    _key.currentState!.openDrawer()),
                          ),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: addPageWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget() {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    dateRappelWidget(),
                    const SizedBox(height: p8),
                    buildTitle(),
                    const SizedBox(height: p8),
                    buildDescription(),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit();
                            form.reset();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dateRappelWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Rappel',
          ),
          controller: dateRappelController,
          firstDate: DateTime(2000),
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

  Widget buildTitle() {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    return TextFormField(
      maxLines: 1,
      style: bodyText1,
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

  Widget buildDescription() {
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return TextFormField(
      maxLines: 10,
      style: bodyText2,
      controller: descriptionController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Ecrivez quelque chose...',
        // hintStyle: TextStyle(color: Colors.black54),
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
        id: widget.agendaColor.agendaModel.id!,
        title: titleController.text,
        description: descriptionController.text,
        dateRappel: DateTime.parse(dateRappelController.text),
        signature: user!.matricule.toString(),
        created: DateTime.now());
    await AgendaApi().updateData(agendaModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Modification effectué avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
