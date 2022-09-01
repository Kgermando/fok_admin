import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/table_produit_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class ProduitModelPage extends StatefulWidget {
  const ProduitModelPage({Key? key}) : super(key: key);

  @override
  State<ProduitModelPage> createState() => _ProduitModelPageState();
}

class _ProduitModelPageState extends State<ProduitModelPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: "Nouvelle probuit model",
            backgroundColor: mainColor,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(
                  context, ComMarketingRoutes.comMarketingProduitModelAdd);
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
                      const Expanded(child: TableProduitModel())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
