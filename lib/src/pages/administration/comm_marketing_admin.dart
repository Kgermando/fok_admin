import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/comm_marketing/campaign_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/comm_marketing/succursale_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/comm_marketing/table_campaign_dg.dart';
import 'package:fokad_admin/src/pages/administration/components/comm_marketing/table_succursale_dg.dart';

class CommMarketingAdmin extends StatefulWidget {
  const CommMarketingAdmin({Key? key}) : super(key: key);

  @override
  State<CommMarketingAdmin> createState() => _CommMarketingAdminState();
}

class _CommMarketingAdminState extends State<CommMarketingAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenCom1 = false;
  bool isOpenCom2 = false;

  int campaignCount = 0;
  int succursaleCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var campaigns = await CampaignNotifyApi().getCountDG();
    var succursales = await SuccursaleNotifyApi().getCountDG();

    setState(() {
      campaignCount = campaigns.count;
      succursaleCount = succursales.count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: Responsive.isDesktop(context)
                              ? 'Commercial & Marketing'
                              : 'Comm. & Mark.',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.orange.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Campagnes',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $campaignCount dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenCom1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableCampaignDG()],
                              ),
                            ),
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Succursale',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $succursaleCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenCom2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableSuccursaleDG()],
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
