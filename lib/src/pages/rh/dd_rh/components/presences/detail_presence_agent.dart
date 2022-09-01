import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/rh/presence_personnel_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/presence_personnel_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/plateforms/desktop/detail_presence_desktop.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/plateforms/mobile/detail_presence_mobile.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/plateforms/tablet/detail_presence_tablet.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:flutter/material.dart';

class DetailPresenceAgent extends StatefulWidget {
  const DetailPresenceAgent({Key? key}) : super(key: key);

  @override
  State<DetailPresenceAgent> createState() => _DetailPresenceAgentState();
}

class _DetailPresenceAgentState extends State<DetailPresenceAgent> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<PresencePersonnelModel> presencePersonnelList = []; // Par mois
  List<PresencePersonnelModel> presencePersonnelListTotal = []; // Cumuls
  List<PresencePersonnelModel> presencePersonnelFilter = [];
  Future<void> getData() async {
    var presencePersonnels = await PresencePersonnelApi().getAllData();
    setState(() {
      presencePersonnelFilter = presencePersonnels;
      // presencePersonnelList = presencePersonnels
      //     .where((element) => element.created.month == DateTime.now().month)
      //     .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
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
                    child: FutureBuilder<AgentModel>(
                        future: AgentsApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<AgentModel> snapshot) {
                          if (snapshot.hasData) {
                            AgentModel? agent = snapshot.data;
                            presencePersonnelListTotal = presencePersonnelFilter
                                .where((element) =>
                                    element.identifiant == agent!.matricule)
                                .toList();
                            presencePersonnelList = presencePersonnelFilter
                                .where((element) =>
                                    element.identifiant == agent!.matricule &&
                                    element.created.month ==
                                        DateTime.now().month)
                                .toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomAppbar(
                                          title: "Personnels",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  if (constraints.maxWidth >= 1100) {
                                    return DetailPresenceDesktop(
                                        presencePersonnelList:
                                            presencePersonnelList,
                                        agent: agent!,
                                        presencePersonnelListTotal:
                                            presencePersonnelListTotal);
                                  } else if (constraints.maxWidth < 1100 &&
                                      constraints.maxWidth >= 650) {
                                    return DetailPresenceTablet(
                                        presencePersonnelList:
                                            presencePersonnelList,
                                        agent: agent!,
                                        presencePersonnelListTotal:
                                            presencePersonnelListTotal);
                                  } else {
                                    return DetailPresenceMobile(
                                        presencePersonnelList:
                                            presencePersonnelList,
                                        agent: agent!,
                                        presencePersonnelListTotal:
                                            presencePersonnelListTotal);
                                  }
                                }))
                              ],
                            );
                          } else {
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }
}
