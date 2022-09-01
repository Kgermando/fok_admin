import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/stock_global_pdf.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/table_history_ravitaillement_produit.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class DetailStockGlobal extends StatefulWidget {
  const DetailStockGlobal({Key? key, required this.stocksGlobalMOdel})
      : super(key: key);
  final StocksGlobalMOdel stocksGlobalMOdel;

  @override
  State<DetailStockGlobal> createState() => _DetailStockGlobalState();
}

class _DetailStockGlobalState extends State<DetailStockGlobal> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  late Future<StocksGlobalMOdel> dataFuture;

  @override
  initState() {
    super.initState();
    dataFuture = getDataFuture();
  }

  Future<StocksGlobalMOdel> getDataFuture() async {
    var achats =
        await StockGlobalApi().getOneData(widget.stocksGlobalMOdel.id!);
    return achats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<StocksGlobalMOdel>(
            future: dataFuture,
            builder: (BuildContext context,
                AsyncSnapshot<StocksGlobalMOdel> snapshot) {
              if (snapshot.hasData) {
                StocksGlobalMOdel? data = snapshot.data;
                return speedialWidget(data!);
              } else {
                return loadingMini();
              }
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
                    child: FutureBuilder<StocksGlobalMOdel>(
                        future: dataFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<StocksGlobalMOdel> snapshot) {
                          if (snapshot.hasData) {
                            StocksGlobalMOdel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (!Responsive.isMobile(context))
                                      SizedBox(
                                        width: p20,
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(Icons.arrow_back)),
                                      ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: Responsive.isDesktop(context)
                                              ? 'Commercial & Marketing'
                                              : 'Comm. & Mark.',
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: pageDetail(data!)))
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

  Widget pageDetail(StocksGlobalMOdel stocksGlobalMOdel) {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: (Responsive.isDesktop(context))
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  if (Responsive.isDesktop(context))
                    TitleWidget(title: stocksGlobalMOdel.idProduct),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              tooltip: "Actualiser la page",
                              color: Colors.green,
                              onPressed: () {
                                setState(() {
                                  dataFuture = getDataFuture();
                                });
                              },
                              icon: const Icon(Icons.refresh)),
                          reporting(stocksGlobalMOdel),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm")
                              .format(stocksGlobalMOdel.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(stocksGlobalMOdel),
              // infosEditeurWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(StocksGlobalMOdel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          achats(data),
          const SizedBox(
            height: 20,
          ),
          disponiblesTitle(),
          disponibles(data),
          const SizedBox(
            height: 30,
          ),
          achatHistorityTitle(),
          const SizedBox(
            height: 20,
          ),
          TableHistoryRavitaillementProduit(stocksGlobalMOdel: data),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget achats(StocksGlobalMOdel stocksGlobalMOdel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    var prixAchatTotal = double.parse(stocksGlobalMOdel.priceAchatUnit) *
        double.parse(stocksGlobalMOdel.quantityAchat);

    var margeBenifice = double.parse(stocksGlobalMOdel.prixVenteUnit) -
        double.parse(stocksGlobalMOdel.priceAchatUnit);
    var margeBenificeTotal =
        margeBenifice * double.parse(stocksGlobalMOdel.quantityAchat);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isMobile(context))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Produit :',
                      textAlign: TextAlign.start,
                      style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                  SelectableText(stocksGlobalMOdel.idProduct,
                      textAlign: TextAlign.start, style: bodyMedium),
                ],
              ),
            if (Responsive.isMobile(context))
              Divider(
                color: mainColor,
              ),
            Row(
              children: [
                Text('Quantités entrant',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(stocksGlobalMOdel.quantityAchat).toStringAsFixed(0)))} ${stocksGlobalMOdel.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('Prix d\'achats unitaire',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(stocksGlobalMOdel.priceAchatUnit).toStringAsFixed(2)))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('Prix d\'achats total',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(prixAchatTotal.toStringAsFixed(2)))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (double.parse(stocksGlobalMOdel.tva) > 1)
              Divider(
                color: mainColor,
              ),
            if (double.parse(stocksGlobalMOdel.tva) > 1)
              Row(
                children: [
                  Text('TVA',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text('${stocksGlobalMOdel.tva} %',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('Prix de vente unitaire',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(stocksGlobalMOdel.prixVenteUnit).toStringAsFixed(2)))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: mainColor,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Responsive.isDesktop(context)
                ? Row(
                    children: [
                      Text('Marge bénéficiaire unitaire',
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.orange)
                              : bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$',
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.orange)
                              : bodyMedium,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Marge bénéficiaire unitaire',
                          textAlign: TextAlign.left,
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.orange)
                              : bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$',
                          textAlign: TextAlign.left,
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.orange)
                              : bodyMedium,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
            Divider(
              color: mainColor,
            ),
            Responsive.isDesktop(context)
                ? Row(
                    children: [
                      Text('Marge bénéficiaire total',
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFE64A19))
                              : bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$',
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFE64A19))
                              : bodyMedium,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Marge bénéficiaire total',
                          textAlign: TextAlign.left,
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFE64A19))
                              : bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$',
                          textAlign: TextAlign.left,
                          style: Responsive.isDesktop(context)
                              ? const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFFE64A19))
                              : bodyMedium,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget disponiblesTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'DISPONIBLES',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget disponibles(StocksGlobalMOdel stocksGlobalMOdel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    var prixTotalRestante = double.parse(stocksGlobalMOdel.quantity) *
        double.parse(stocksGlobalMOdel.prixVenteUnit);

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restes des ${stocksGlobalMOdel.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyMedium),
              Text('Revenus',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyMedium),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(stocksGlobalMOdel.quantity).toStringAsFixed(0)))} ${stocksGlobalMOdel.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyMedium),
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalRestante.toStringAsFixed(2)))} \$',
                  style: Responsive.isDesktop(context)
                      ? TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.green[800])
                      : bodyMedium),
            ],
          ),
        ],
      ),
    ));
  }

  Widget achatHistorityTitle() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'FICHES DE STOCKS',
          textAlign: TextAlign.center,
          style: Responsive.isDesktop(context)
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
              : const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget reporting(StocksGlobalMOdel stocksGlobalMOdel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrintWidget(onPressed: () async {
          await StockGlobalPdf.generate(stocksGlobalMOdel);
        })
      ],
    );
  }

  SpeedDial speedialWidget(StocksGlobalMOdel stocksGlobalMOdel) {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.reply),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Ravitaillement',
          onPressed: () {
            Navigator.pushNamed(context,
                ComMarketingRoutes.comMarketingStockGlobalRavitaillement,
                arguments: stocksGlobalMOdel);
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.local_shipping),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade700,
            label: 'Livraison',
            onPressed: () {
              Navigator.pushNamed(context,
                  ComMarketingRoutes.comMarketingStockGlobalLivraisonStock,
                  arguments: stocksGlobalMOdel);
            }),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
