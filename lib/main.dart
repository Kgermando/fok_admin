import 'package:flutter/foundation.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/providers/notify_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fokad_admin/src/providers/theme_provider.dart';
import 'package:fokad_admin/src/providers/controller.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  setPathUrlStrategy();
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  UserModel user = await AuthApi().getUserId();
  runApp(Phoenix(child: MyApp(user: user)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("departement ${user.departement}");
    }
    String homeRoute = "";
    if (user.departement == '-') {
      homeRoute = UserRoutes.login;
    } else {
      if (user.departement == "Administration") {
        if (int.parse(user.role) <= 2) {
          homeRoute = AdminRoutes.adminDashboard;
        } else {
          homeRoute = AdminRoutes.adminLogistique;
        }
      } else if (user.departement == "Finances") {
        if (int.parse(user.role) <= 2) {
          homeRoute = FinanceRoutes.financeDashboard;
        } else {
          homeRoute = FinanceRoutes.transactionsDettes;
        }
      } else if (user.departement == "Comptabilites") {
        if (int.parse(user.role) <= 2) {
          homeRoute = ComptabiliteRoutes.comptabiliteDashboard;
        } else {
          homeRoute = ComptabiliteRoutes.comptabiliteJournalLivre;
        }
      } else if (user.departement == "Budgets") {
        if (int.parse(user.role) <= 2) {
          homeRoute = BudgetRoutes.budgetDashboard;
        } else {
          homeRoute = BudgetRoutes.budgetBudgetPrevisionel;
        }
      } else if (user.departement == "Ressources Humaines") {
        if (int.parse(user.role) <= 2) {
          homeRoute = RhRoutes.rhDashboard;
        } else {
          homeRoute = RhRoutes.rhPresence;
        }
      } else if (user.departement == "Exploitations") {
        if (int.parse(user.role) <= 2) {
          homeRoute = ExploitationRoutes.expDashboard;
        } else {
          homeRoute = ExploitationRoutes.expTache;
        }
      } else if (user.departement == "Commercial et Marketing") {
        if (int.parse(user.role) <= 2) {
          homeRoute = ComMarketingRoutes.comMarketingDashboard;
        } else {
          homeRoute = ComMarketingRoutes.comMarketingAnnuaire;
        }
      } else if (user.departement == "Logistique") {
        if (int.parse(user.role) <= 2) {
          homeRoute = LogistiqueRoutes.logDashboard;
        } else {
          homeRoute = LogistiqueRoutes.logAnguinAuto;
        }
      } else if (user.departement == "Support") {
        homeRoute = AdminRoutes.adminDashboard; 
      } else {
        
      }
    }

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Controller()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => NotifyProvider()),
          ChangeNotifierProvider(create: (context) => UserSharedPref())
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: InfoSystem().name(),
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            initialRoute: homeRoute,
            routes: routes,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
          );
        });
  }
}
