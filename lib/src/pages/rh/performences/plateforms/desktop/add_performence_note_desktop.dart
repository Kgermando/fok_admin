import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/rh/performence_note_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddPerformenceNoteDesktop extends StatefulWidget {
  const AddPerformenceNoteDesktop(
      {Key? key, required this.performenceModel, required this.signature})
      : super(key: key);
  final PerformenceModel performenceModel;
  final String signature;

  @override
  State<AddPerformenceNoteDesktop> createState() =>
      _AddPerformenceNoteDesktopState();
}

class _AddPerformenceNoteDesktopState extends State<AddPerformenceNoteDesktop> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController hospitaliteController = TextEditingController();
  final TextEditingController ponctualiteController = TextEditingController();
  final TextEditingController travailleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    hospitaliteController.dispose();
    ponctualiteController.dispose();
    travailleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return addAgentWidget(widget.performenceModel);
  }

  Widget addAgentWidget(PerformenceModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                width: MediaQuery.of(context).size.width / 2,
                child: ListView(
                  children: [
                    const TitleWidget(title: "Ajout performence"),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('Nom :',
                              textAlign: TextAlign.start,
                              style: bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(data.nom,
                              textAlign: TextAlign.start, style: bodyMedium),
                        )
                      ],
                    ),
                    Divider(
                      color: mainColor,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('Post-Nom :',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(data.postnom,
                              textAlign: TextAlign.start, style: bodyMedium),
                        )
                      ],
                    ),
                    Divider(
                      color: mainColor,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('Prénom:',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(data.prenom,
                              textAlign: TextAlign.start, style: bodyMedium),
                        )
                      ],
                    ),
                    Divider(
                      color: mainColor,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('Agent :',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(data.agent,
                              textAlign: TextAlign.start, style: bodyMedium),
                        )
                      ],
                    ),
                    Divider(
                      color: mainColor,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('Département :',
                              textAlign: TextAlign.start,
                              style: bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: SelectableText(data.departement,
                              textAlign: TextAlign.start, style: bodyMedium),
                        )
                      ],
                    ),
                    Divider(
                      color: mainColor,
                    ),
                    Row(
                      children: [
                        Expanded(child: hospitaliteWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: ponctualiteWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: travailleWidget())
                      ],
                    ),
                    noteWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit(data);
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

  Widget hospitaliteWidget() {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: hospitaliteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Hospitalité',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]$|^10$')),
                ],
                style: const TextStyle(),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Text("/10",
                    style:
                        headlineMedium!.copyWith(color: Colors.blue.shade700)))
          ],
        ));
  }

  Widget ponctualiteWidget() {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: ponctualiteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Ponctualité',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]$|^10$')),
                ],
                style: const TextStyle(),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Text("/10",
                    style:
                        headlineMedium!.copyWith(color: Colors.green.shade700)))
          ],
        ));
  }

  Widget travailleWidget() {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: travailleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Travaille',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]$|^10$')),
                ],
                style: const TextStyle(),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Text("/10",
                    style: headlineMedium!
                        .copyWith(color: Colors.purple.shade700)))
          ],
        ));
  }

  Widget noteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: noteController,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Note',
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

  Future<void> submit(PerformenceModel data) async {
    final performenceNoteModel = PerformenceNoteModel(
        agent: data.agent,
        departement: data.departement,
        hospitalite: hospitaliteController.text,
        ponctualite: ponctualiteController.text,
        travaille: travailleController.text,
        note: noteController.text,
        signature: widget.signature,
        created: DateTime.now());
    await PerformenceNoteApi().insertData(performenceNoteModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
