import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/providers/theme_provider.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool isloading = false;

  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final versionSoft = "";

  @override
  Widget build(BuildContext context) {
    var headline6 = Theme.of(context).textTheme.headline6;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.all(50.0)
            : const EdgeInsets.all(10.0),
        child: Card(
          elevation: 10,
          shadowColor: Colors.deepPurpleAccent,
          child: Row(
            children: [
              if (!Responsive.isMobile(context))
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(InfoSystem().logo(),
                            fit: BoxFit.contain,
                            height: Responsive.isDesktop(context)
                                ? height / 1.5
                                : height / 2),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 20,
                        child: DefaultTextStyle(
                          style: headline6!.copyWith(color: Colors.black),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                  'Bienvenue sur l\'interface d\'administration ${InfoSystem().name()}.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  '${InfoSystem().name()}, vous donne le contrôle de votre business:',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Ce logiciel vous rapproche de perfection.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Il vous permet entre-autre de:',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Gerer vos rapports instanement.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Gerer votre Budgets global ou par département.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText('Gerer votre Finance.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Gerer votre Comptabilité.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Gerer vos Projets au quotidien.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Gerer les Ressources Humaines.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText('Gerer la logistique.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Gerer le Commerciale et Maketing.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Gerer votre Annuaire et Partenaire.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText('Gerer votre Agenda.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Redigez et envoyez vos mails.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                              TypewriterAnimatedText(
                                  'Travaillez partout et à tous moment.',
                                  textStyle: TextStyle(
                                      color: ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              Expanded(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(p10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.topRight, child: helpWidget()),
                        logoWidget(),
                        // titleText(),
                        const SizedBox(height: p10),
                        userNameBuild(),
                        const SizedBox(height: p10),
                        passwordBuild(),
                        const SizedBox(height: p10),
                        loginButtonBuild(),
                        // const SizedBox(height: p10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            forgotPasswordWidget(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget logoWidget() {
    var height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    final headline6 = Theme.of(context).textTheme.headline6;
    return Column(
      children: [
        Image.asset(
          InfoSystem().logo(),
          height: Responsive.isDesktop(context) ? 100 : height / 5,
          width: size.width,
        ),
        const SizedBox(height: p10),
        AutoSizeText('ASTRID SOFTWARE',
            style: headline6!.copyWith(fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget userNameBuild() {
    return Padding(
        padding: const EdgeInsets.all(p20),
        child: TextFormField(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Matricule',
          ),
          controller: matriculeController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ce champ est obligatoire';
            }
            return null;
          },
          style: const TextStyle(),
        ));
  }

  Widget passwordBuild() {
    return Padding(
        padding: const EdgeInsets.all(p20),
        child: TextFormField(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Mot de passe',
          ),
          controller: passwordController,
          keyboardType: TextInputType.text,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ce champ est obligatoire';
            }
            return null;
          },
          style: const TextStyle(),
        ));
  }

  Widget loginButtonBuild() {
    return Padding(
      padding: const EdgeInsets.all(p20),
      child: BtnWidget(
          title: 'Login',
          isLoading: isloading,
          press: () async {
            final form = _form.currentState!;
            if (form.validate()) {
              setState(() => isloading = true);
              await AuthApi()
                  .login(matriculeController.text, passwordController.text)
                  .then((value) async {
                if (value) {
                  await updateIsOnline();
                  await AuthApi().getUserId().then((user) {
                    if (user.departement == "Administration") {
                      if (int.parse(user.role) <= 2) {
                        Navigator.pushNamed(
                            context, AdminRoutes.adminDashboard);
                      } else {
                        Navigator.pushNamed(
                            context, AdminRoutes.adminLogistique);
                      }
                    } else if (user.departement == "Finances") {
                      if (int.parse(user.role) <= 2) {
                        Navigator.pushNamed(
                            context, FinanceRoutes.financeDashboard);
                      } else {
                        Navigator.pushNamed(
                            context, FinanceRoutes.transactionsDettes);
                      }
                    } else if (user.departement == "Comptabilites") {
                      if (int.parse(user.role) <= 2) {
                        Navigator.pushNamed(
                            context, ComptabiliteRoutes.comptabiliteDashboard);
                      } else {
                        Navigator.pushNamed(context,
                            ComptabiliteRoutes.comptabiliteJournalLivre);
                      }
                    } else if (user.departement == "Budgets") {
                      if (int.parse(user.role) <= 2) {
                        Navigator.pushNamed(
                            context, BudgetRoutes.budgetDashboard);
                      } else {
                        Navigator.pushNamed(
                            context, BudgetRoutes.budgetBudgetPrevisionel);
                      }
                    } else if (user.departement == "Ressources Humaines") {
                      if (int.parse(user.role) <= 2) {
                        Navigator.pushNamed(context, RhRoutes.rhDashboard);
                      } else {
                        Navigator.pushNamed(context, RhRoutes.rhPresence);
                      }
                    } else if (user.departement == "Exploitations") {
                      if (int.parse(user.role) <= 2) {
                        Navigator.pushNamed(
                            context, ExploitationRoutes.expDashboard);
                      } else {
                        Navigator.pushNamed(
                            context, ExploitationRoutes.expTache);
                      }
                    } else if (user.departement == "Commercial et Marketing") {
                      if (int.parse(user.role) <= 2) {
                        Navigator.pushNamed(
                            context, ComMarketingRoutes.comMarketingDashboard);
                      } else {
                        Navigator.pushNamed(
                            context, ComMarketingRoutes.comMarketingAnnuaire);
                      }
                    } else if (user.departement == "Logistique") {
                      if (int.parse(user.role) <= 2) {
                        Navigator.pushNamed(
                            context, LogistiqueRoutes.logDashboard);
                      } else {
                        Navigator.pushNamed(
                            context, LogistiqueRoutes.logAnguinAuto);
                      }
                    } else if (user.departement == "Support") {
                      Navigator.pushNamed(context, AdminRoutes.adminDashboard);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Login succès!"),
                      backgroundColor: Colors.green[700],
                    ));
                    setState(() => isloading = false);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        "Votre Matricule ou Mot de passe incorrect ou encore verifiez votre connexion internet."),
                    backgroundColor: Colors.red[700],
                  ));
                  setState(() => isloading = false);
                }
              });
            }
          }),
    );
  }

  Widget forgotPasswordWidget() {
    final button = Theme.of(context).textTheme.button;
    return TextButton(
        onPressed: () {},
        child: Text(
          'Mot de passe oublié ?',
          style: button,
          textAlign: TextAlign.start,
        ));
  }

  Widget helpWidget() {
    final button = Theme.of(context).textTheme.button;
    return TextButton.icon(
        onPressed: () {},
        icon: const Icon(
          Icons.help,
          color: Colors.teal,
        ),
        label: Text(
          'Besoin d\'aide?',
          style: button,
        ));
  }

  Future<void> updateIsOnline() async {
    final user = await AuthApi().getUserId();
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
        isOnline: 'true',
        createdAt: user.createdAt,
        passwordHash: user.passwordHash,
        succursale: user.succursale);
    await UserApi().updateData(userModel);
  }
}
