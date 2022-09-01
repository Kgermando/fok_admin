import 'package:fokad_admin/src/pages/rh/agents/plateforms/desktop/update_agent_desktop.dart';
import 'package:fokad_admin/src/pages/rh/agents/plateforms/mobile/update_agent_mobile.dart';
import 'package:fokad_admin/src/pages/rh/agents/plateforms/tablet/update_agent_tablet.dart';
import 'package:fokad_admin/src/utils/country.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/fonction_occupe.dart';
import 'package:fokad_admin/src/utils/service_affectation.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_count_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

class UpdateAgent extends StatefulWidget {
  const UpdateAgent({Key? key, required this.agentModel}) : super(key: key);
  final AgentModel agentModel;

  @override
  State<UpdateAgent> createState() => _UpdateAgentState();
}

class _UpdateAgentState extends State<UpdateAgent> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final List<String> departementList = Dropdown().departement;
  final List<String> typeContratList = Dropdown().typeContrat;
  final List<String> sexeList = Dropdown().sexe;
  final List<String> world = Country().world;

  // Fontion occupée
    final List<String> fonctionActionnaireList =
      FonctionOccupee().actionnaireDropdown;
  final List<String> fonctionAdminList = FonctionOccupee().adminDropdown;
  final List<String> fonctionrhList = FonctionOccupee().rhDropdown;
  final List<String> fonctionfinList = FonctionOccupee().finDropdown;
  final List<String> fonctionbudList = FonctionOccupee().budDropdown;
  final List<String> fonctioncompteList = FonctionOccupee().compteDropdown;
  final List<String> fonctionexpList = FonctionOccupee().expDropdown;
  final List<String> fonctioncommList = FonctionOccupee().commDropdown;
  final List<String> fonctionlogList = FonctionOccupee().logDropdown;

  // Service d'affectation
  final List<String> serviceAffectationActionnaire =
      ServiceAffectation().actionnaireDropdown;
  final List<String> serviceAffectationAdmin =
      ServiceAffectation().adminDropdown;
  final List<String> serviceAffectationRH = ServiceAffectation().rhDropdown;
  final List<String> serviceAffectationFin = ServiceAffectation().finDropdown;
  final List<String> serviceAffectationBud =
      ServiceAffectation().budgetDropdown;
  final List<String> serviceAffectationCompt =
      ServiceAffectation().comptableDropdown;
  final List<String> serviceAffectationEXp = ServiceAffectation().expDropdown;
  final List<String> serviceAffectationComm = ServiceAffectation().commDropdown;
  final List<String> serviceAffectationLog = ServiceAffectation().logDropdown;

  UserModel? user;
  AgentCountModel? agentCount;
  Future<void> getData() async {
    final data = await AgentsApi().getCount();
    setState(() {
      agentCount = data;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                    _key.currentState!.openDrawer()),
                          ),
                        ],
                      ),
                      Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth >= 1100) {
                          return UpdateAgentDesktop(
                              departementList: departementList,
                              typeContratList: typeContratList,
                              sexeList: sexeList,
                              world: world,
                              fonctionActionnaireList: fonctionActionnaireList,
                              fonctionAdminList: fonctionAdminList,
                              fonctionrhList: fonctionrhList,
                              fonctionfinList: fonctionfinList,
                              fonctionbudList: fonctionbudList,
                              fonctioncompteList: fonctioncompteList,
                              fonctionexpList: fonctionexpList,
                              fonctioncommList: fonctioncommList,
                              fonctionlogList: fonctionlogList,
                              serviceAffectationActionnaire:
                                  serviceAffectationActionnaire,
                              serviceAffectationAdmin: serviceAffectationAdmin,
                              serviceAffectationRH: serviceAffectationRH,
                              serviceAffectationFin: serviceAffectationFin,
                              serviceAffectationBud: serviceAffectationBud,
                              serviceAffectationCompt: serviceAffectationCompt,
                              serviceAffectationEXp: serviceAffectationEXp,
                              serviceAffectationComm: serviceAffectationComm,
                              serviceAffectationLog: serviceAffectationLog,
                              agentModel: widget.agentModel);
                        } else if (constraints.maxWidth < 1100 &&
                            constraints.maxWidth >= 650) {
                          return UpdateAgentTablet(
                              departementList: departementList,
                              typeContratList: typeContratList,
                              sexeList: sexeList,
                              world: world,
                              fonctionActionnaireList: fonctionActionnaireList,
                              fonctionAdminList: fonctionAdminList,
                              fonctionrhList: fonctionrhList,
                              fonctionfinList: fonctionfinList,
                              fonctionbudList: fonctionbudList,
                              fonctioncompteList: fonctioncompteList,
                              fonctionexpList: fonctionexpList,
                              fonctioncommList: fonctioncommList,
                              fonctionlogList: fonctionlogList,
                              serviceAffectationActionnaire:
                                  serviceAffectationActionnaire,
                              serviceAffectationAdmin: serviceAffectationAdmin,
                              serviceAffectationRH: serviceAffectationRH,
                              serviceAffectationFin: serviceAffectationFin,
                              serviceAffectationBud: serviceAffectationBud,
                              serviceAffectationCompt: serviceAffectationCompt,
                              serviceAffectationEXp: serviceAffectationEXp,
                              serviceAffectationComm: serviceAffectationComm,
                              serviceAffectationLog: serviceAffectationLog,
                              agentModel: widget.agentModel);
                        } else {
                          return UpdateAgentMobile(
                              departementList: departementList,
                              typeContratList: typeContratList,
                              sexeList: sexeList,
                              world: world,
                              fonctionActionnaireList: fonctionActionnaireList,
                              fonctionAdminList: fonctionAdminList,
                              fonctionrhList: fonctionrhList,
                              fonctionfinList: fonctionfinList,
                              fonctionbudList: fonctionbudList,
                              fonctioncompteList: fonctioncompteList,
                              fonctionexpList: fonctionexpList,
                              fonctioncommList: fonctioncommList,
                              fonctionlogList: fonctionlogList,
                              serviceAffectationActionnaire:
                                  serviceAffectationActionnaire,
                              serviceAffectationAdmin: serviceAffectationAdmin,
                              serviceAffectationRH: serviceAffectationRH,
                              serviceAffectationFin: serviceAffectationFin,
                              serviceAffectationBud: serviceAffectationBud,
                              serviceAffectationCompt: serviceAffectationCompt,
                              serviceAffectationEXp: serviceAffectationEXp,
                              serviceAffectationComm: serviceAffectationComm,
                              serviceAffectationLog: serviceAffectationLog,
                              agentModel: widget.agentModel);
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
