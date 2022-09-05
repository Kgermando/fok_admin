import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/immobilier_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/table_immobilier.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class ImmobilierMateriel extends StatefulWidget {
  const ImmobilierMateriel({Key? key}) : super(key: key);

  @override
  State<ImmobilierMateriel> createState() => _ImmobilierMaterielState();
}

class _ImmobilierMaterielState extends State<ImmobilierMateriel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController typeAllocationController =
      TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController numeroCertificatController =
      TextEditingController();
  final TextEditingController superficieController = TextEditingController();
  final TextEditingController dateAcquisitionController =
      TextEditingController();

  @override
  initState() {
    date();
    super.initState();
  }

  String? signature;
  Future<void> date() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
    });
  }

  @override
  void dispose() {
    typeAllocationController.dispose();
    adresseController.dispose();
    numeroCertificatController.dispose();
    superficieController.dispose();
    dateAcquisitionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              // Navigator.pushNamed(context, LogistiqueRoutes.logAddImmobilerMateriel);
              newFicheDialog();
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
                          title: 'Logistique',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableImmobilier())
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
            isLoading = false;
            return AlertDialog(
              scrollable: true,
              title:
                  Text('Ajout immobilier', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: Responsive.isDesktop(context) ? 350 : 600,
                  width: 500,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Responsive.isMobile(context)
                                  ? Column(
                                      children: [
                                        typeAllocationWidget(),
                                        adresseWidget()
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(child: typeAllocationWidget()),
                                        const SizedBox(
                                          width: p10,
                                        ),
                                        Expanded(child: adresseWidget())
                                      ],
                                    ),
                              Responsive.isMobile(context)
                                  ? Column(
                                      children: [
                                        numeroCertificatWidget(),
                                        superficieWidget()
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: numeroCertificatWidget()),
                                        const SizedBox(
                                          width: p10,
                                        ),
                                        Expanded(child: superficieWidget())
                                      ],
                                    ),
                              dateAcquisitionWidget(),
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
                    isLoading = true;
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

  Widget typeAllocationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: typeAllocationController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Type d\'Allocation',
              hintText: 'Bureau, Entrepôt,...'),
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

  Widget adresseWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: adresseController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Adresse',
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

  Widget numeroCertificatWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: numeroCertificatController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Numéro certificat',
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

  Widget superficieWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: superficieController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Superficie',
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

  Widget dateAcquisitionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date d\'acquisition',
          ),
          controller: dateAcquisitionController,
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

  Future<void> submit() async {
    final immobilierModel = ImmobilierModel(
        typeAllocation: typeAllocationController.text,
        adresse: adresseController.text,
        numeroCertificat: numeroCertificatController.text,
        superficie: superficieController.text,
        dateAcquisition: DateTime.parse(dateAcquisitionController.text),
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        approbationDG: 'Approved',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: 'Approved',
        motifDD: '-',
        signatureDD: '-');
    await ImmobilierApi().insertData(immobilierModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
