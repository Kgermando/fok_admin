import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailUserDesktop extends StatefulWidget {
  const DetailUserDesktop(
      {Key? key, required this.user, required this.succursaleList})
      : super(key: key);
  final UserModel user;
  final List<SuccursaleModel> succursaleList;

  @override
  State<DetailUserDesktop> createState() => _DetailUserDesktopState();
}

class _DetailUserDesktopState extends State<DetailUserDesktop> {
  bool isLoading = false;

  String? succursale;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return pageDetail(widget.user);
  }

  Widget pageDetail(UserModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TitleWidget(title: "Matricule ${data.matricule}"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(p8),
                    child: SelectableText(
                        DateFormat("dd-MM-yyyy HH:mm").format(data.createdAt)),
                  )
                ],
              ),
              dataWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(UserModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Prenom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.prenom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.matricule,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('departement :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Services d\'Affectation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.servicesAffectation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Fonction Occupée :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.fonctionOccupe,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Accreditation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.role,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          // if (data.succursale != '-')
          Row(
            children: [
              Expanded(
                child: Text('Succursale :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Column(
                  children: [
                    SelectableText(data.succursale,
                        textAlign: TextAlign.start, style: bodyMedium),
                    const SizedBox(height: p20),
                    succursaleWidget(data)
                  ],
                ),
              )
            ],
          ),
          Divider(color: mainColor),
        ],
      ),
    );
  }

  Widget succursaleWidget(UserModel user) {
    var succList = widget.succursaleList.map((e) => e.name).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Succursale',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: succursale,
        isExpanded: true,
        items: succList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select Nationalite" : null,
        onChanged: (value) {
          setState(() {
            succursale = value!;
            succursaleUser(user);
          });
        },
      ),
    );
  }

  Future<void> succursaleUser(UserModel user) async {
    final userModel = UserModel(
        id: user.id,
        nom: user.nom,
        prenom: user.prenom,
        email: user.email,
        telephone: user.telephone,
        matricule: user.matricule,
        departement: user.departement,
        servicesAffectation: user.servicesAffectation,
        fonctionOccupe: user.fonctionOccupe,
        role: user.role,
        isOnline: user.isOnline,
        createdAt: user.createdAt,
        passwordHash: user.passwordHash,
        succursale: succursale.toString());
    await UserApi().updateData(userModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Succursale mise à jour avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
