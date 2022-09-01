import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class MailsNAv extends StatefulWidget {
  const MailsNAv({Key? key}) : super(key: key);

  @override
  State<MailsNAv> createState() => _MailsNAvState();
}

class _MailsNAvState extends State<MailsNAv> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    String? pageCurrente = ModalRoute.of(context)!.settings.name;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Image.asset(
            InfoSystem().logo(),
            width: 100,
            height: 100,
          )),
          IconButton(
              color: mainColor,
              onPressed: () async {
                await AuthApi().getUserId().then((user) {
                  if (user.departement == "Administration") {
                    if (int.parse(user.role) <= 2) {
                      Navigator.pushNamed(context, AdminRoutes.adminDashboard);
                    } else {
                      Navigator.pushNamed(context, AdminRoutes.adminLogistique);
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
                      Navigator.pushNamed(
                          context, ComptabiliteRoutes.comptabiliteJournalLivre);
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
                      Navigator.pushNamed(context, ExploitationRoutes.expTache);
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
                  }
                });
              },
              icon: Row(
                children: const [
                  Icon(Icons.backspace),
                  SizedBox(width: p10),
                  Text("Retour")
                ],
              )),
          const SizedBox(height: p20),
          DrawerWidget(
              selected: pageCurrente == MailRoutes.mails,
              icon: Icons.inbox,
              sizeIcon: 20.0,
              title: 'Boite de reception',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(context, MailRoutes.mails);
                // Navigator.of(context).pop();
              }),
          DrawerWidget(
              selected: pageCurrente == MailRoutes.mailSend,
              icon: Icons.send,
              sizeIcon: 20.0,
              title: "Boite d'envoie",
              style: bodyText1,
              onTap: () {
                Navigator.pushNamed(context, MailRoutes.mailSend);
                // Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}
