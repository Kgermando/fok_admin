import 'package:fokad_admin/src/pages/rh/paiements/plateforms/desktop/add_salaire_desktop.dart';
import 'package:fokad_admin/src/pages/rh/paiements/plateforms/mobile/add_salaire_mobile.dart';
import 'package:fokad_admin/src/pages/rh/paiements/plateforms/tablet/add_salaire_tablet.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/salaire_dropsown.dart';

class AddPaiementSalaire extends StatefulWidget {
  const AddPaiementSalaire({Key? key}) : super(key: key);

  @override
  State<AddPaiementSalaire> createState() => _AddPaiementSalaireState();
}

class _AddPaiementSalaireState extends State<AddPaiementSalaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final List<String> tauxJourHeureMoisSalaireList =
      SalaireDropdown().tauxJourHeureMoisSalaireDropdown;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<PaiementSalaireModel> paiementList = [];
  String signature = '';
  Future<void> getData() async {
    UserModel user = await AuthApi().getUserId();
    var paiements = await PaiementSalaireApi().getAllData();
    if (!mounted) return;
    setState(() {
      signature = user.matricule;
      paiementList = paiements
          .where((element) =>
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final agentModel = ModalRoute.of(context)!.settings.arguments as AgentModel;

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
                          if (!Responsive.isMobile(context))
                            SizedBox(
                              width: p20,
                              child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back)),
                            ),
                          const SizedBox(width: p10),
                          Expanded(
                              child: CustomAppbar(
                                  title: (Responsive.isDesktop(context))
                                      ? "Ressources Humaines"
                                      : "RH",
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth >= 1100) {
                          return AddSalaireDestop(
                              paiementList: paiementList,
                              signature: signature,
                              agentModel: agentModel,
                              tauxJourHeureMoisSalaireList:
                                  tauxJourHeureMoisSalaireList);
                        } else if (constraints.maxWidth < 1100 &&
                            constraints.maxWidth >= 650) {
                          return AddSalaireTablet(
                              paiementList: paiementList,
                              signature: signature,
                              agentModel: agentModel,
                              tauxJourHeureMoisSalaireList:
                                  tauxJourHeureMoisSalaireList);
                        } else {
                          return AddSalaireMobile(
                              paiementList: paiementList,
                              signature: signature,
                              agentModel: agentModel,
                              tauxJourHeureMoisSalaireList:
                                  tauxJourHeureMoisSalaireList);
                        }
                      }))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
