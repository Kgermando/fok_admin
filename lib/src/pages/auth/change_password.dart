import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  initState() {
    getData();
    // oldPasswordController =
    //     TextEditingController(text: userModel.passwordHash);
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
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
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: "${userModel.prenom} ${userModel.nom}",
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addPageWidget(userModel),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget(UserModel userModel) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
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
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const TitleWidget(title: 'Modifier votre mot de passe'),
                    const SizedBox(
                      height: p20,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        "Bonjour ${userModel.prenom}, votre sécurité passe avant tout!",
                        maxLines: 3,
                        style: bodyLarge,
                      ),
                    ),
                    const SizedBox(height: p30),
                    newPasswordWidget(),
                    // Row(
                    //   children: [
                    //     Expanded(child: oldPasswordWidget()),
                    //     const SizedBox(
                    //       width: p10,
                    //     ),
                    //     Expanded(child: newPasswordWidget())
                    //   ],
                    // ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submitChangePassword(userModel);
                            form.reset();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                const Text("Mot de passe changer avec succès!"),
                            backgroundColor: Colors.green[700],
                          ));
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

  Widget oldPasswordWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: oldPasswordController,
          readOnly: true,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Ancien mot de passe',
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

  Widget newPasswordWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: newPasswordController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nouveau mot de passe',
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

  Future<void> submitChangePassword(UserModel userModel) async {
    final user = UserModel(
        id: userModel.id,
        nom: userModel.nom,
        prenom: userModel.prenom,
        email: userModel.email,
        telephone: userModel.telephone,
        matricule: userModel.matricule,
        departement: userModel.departement,
        servicesAffectation: userModel.servicesAffectation,
        fonctionOccupe: userModel.fonctionOccupe,
        role: userModel.role,
        isOnline: userModel.isOnline,
        createdAt: userModel.createdAt,
        passwordHash: newPasswordController.text,
        succursale: userModel.succursale);
    await UserApi().changePassword(user);
  }
}
