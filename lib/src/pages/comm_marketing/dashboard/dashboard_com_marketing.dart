import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/creance_facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/gain_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_cart_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/agenda_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/gain_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_cart_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/components/arcticle_plus_vendus.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/components/courbe_vente_gain_mounth.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/components/courbe_vente_gain_year.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/dash_number_widget.dart';
import 'package:intl/intl.dart';

class ComMarketing extends StatefulWidget {
  const ComMarketing({Key? key}) : super(key: key);

  @override
  State<ComMarketing> createState() => _ComMarketingState();
}

class _ComMarketingState extends State<ComMarketing> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  int campaignCount = 0;
  int annuaireCount = 0;
  int agendaCount = 0;
  int succursaleCount = 0;
  double venteCount = 0.0;
  double gainCount = 0.0;

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      getData();
      timer.cancel();
    }));

    super.initState();
  }

  List<VenteCartModel> ventesList = [];
  List<GainModel> gainsList = [];
  List<CreanceCartModel> creanceFactureList = [];
  Future<void> getData() async {
    var ventes = await VenteCartApi().getAllData();
    var gains = await GainApi().getAllData();
    var creanceFacture = await CreanceFactureApi().getAllData();
    var campaigns = await CampaignApi().getAllData();
    var annuaires = await AnnuaireApi().getAllData();
    var agendas = await AgendaApi().getAllData();
    var succursales = await SuccursaleApi().getAllData();

    setState(() {
      ventesList = ventes;
      gainsList = gains;
      creanceFactureList = creanceFacture;

      campaignCount = campaigns
          .where((element) =>
              element.approbationDD == "Approved" &&
              element.approbationBudget == "Approved" &&
              element.approbationFin == "Approved")
          .length;
      succursaleCount = succursales
          .where((element) => element.approbationDD == "Approved")
          .length;

      annuaireCount = annuaires.length;
      agendaCount = agendas.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gain
    double sumGain = 0;
    var dataGain = gainsList.map((e) => e.sum).toList();
    for (var data in dataGain) {
      sumGain += data;
    }

    // Ventes
    double sumVente = 0;
    var dataPriceVente =
        ventesList.map((e) => double.parse(e.priceTotalCart)).toList();
    for (var data in dataPriceVente) {
      sumVente += data;
    }

    // Créances
    double sumDCreance = 0;
    for (var item in creanceFactureList) {
      final cartItem = jsonDecode(item.cart) as List;
      List<CartModel> cartItemList = [];

      for (var element in cartItem) {
        cartItemList.add(CartModel.fromJson(element));
      }

      for (var data in cartItemList) {
        if (double.parse(data.quantityCart) >= double.parse(data.qtyRemise)) {
          double total =
              double.parse(data.remise) * double.parse(data.quantityCart);
          sumDCreance += total;
        } else {
          double total =
              double.parse(data.priceCart) * double.parse(data.quantityCart);
          sumDCreance += total;
        }
      }
    }

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
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                DashNumberWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(context,
                                          ComMarketingRoutes.comMarketingVente);
                                    },
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(sumVente)} \$',
                                    title: 'Ventes',
                                    icon: Icons.shopping_cart,
                                    color: Colors.purple.shade700),
                                DashNumberWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(context,
                                          ComMarketingRoutes.comMarketingVente);
                                    },
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(sumGain)} \$',
                                    title: 'Gains',
                                    icon: Icons.grain,
                                    color: Colors.green.shade700),
                                DashNumberWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context,
                                          ComMarketingRoutes
                                              .comMarketingCreance);
                                    },
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(sumDCreance)} \$',
                                    title: 'Créances',
                                    icon: Icons.money_off_outlined,
                                    color: Colors.pink.shade700),
                                DashNumberWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context,
                                          ComMarketingRoutes
                                              .comMarketingSuccursale);
                                    },
                                    number: '$succursaleCount',
                                    title: 'Succursale',
                                    icon: Icons.house,
                                    color: Colors.brown.shade700),
                                DashNumberWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context,
                                          ComMarketingRoutes
                                              .comMarketingCampaign);
                                    },
                                    number: '$campaignCount',
                                    title: 'Campagnes',
                                    icon: Icons.campaign,
                                    color: Colors.orange.shade700),
                                DashNumberWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context,
                                          ComMarketingRoutes
                                              .comMarketingAnnuaire);
                                    },
                                    number: '$annuaireCount',
                                    title: 'Annuaire',
                                    icon: Icons.group,
                                    color: Colors.yellow.shade700),
                                DashNumberWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context,
                                          ComMarketingRoutes
                                              .comMarketingAgenda);
                                    },
                                    number: '$agendaCount',
                                    title: 'Agenda',
                                    icon: Icons.checklist_rtl,
                                    color: Colors.teal.shade700),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Responsive.isDesktop(context)
                                ? Row(
                                    children: const [
                                      Expanded(child: CourbeVenteGainMounth()),
                                      Expanded(child: CourbeVenteGainYear()),
                                    ],
                                  )
                                : Column(
                                    children: const [
                                      CourbeVenteGainMounth(),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      CourbeVenteGainYear(),
                                    ],
                                  ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Wrap(
                              children: const [
                                ArticlePlusVendus(),
                              ],
                            )
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
