import 'package:fokad_admin/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_cart_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/achats/components/achat_pdf.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailAchat extends StatefulWidget {
  const DetailAchat({Key? key, required this.achatModel}) : super(key: key);
  final AchatModel achatModel;

  @override
  State<DetailAchat> createState() => _DetailAchatState();
}

class _DetailAchatState extends State<DetailAchat> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  late Future<AchatModel> dataFuture;

  @override
  initState() {
    getData();
    dataFuture = getDataFuture();
    super.initState();
  }

  // All ventes
  List<VenteCartModel> venteCartList = [];

  // AchatModel? achatModel;

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var ventes = await VenteCartApi().getAllData();
    setState(() {
      user = userModel;
      venteCartList = ventes;
    });
  }

  Future<AchatModel> getDataFuture() async {
    var achats = await AchatApi().getOneData(widget.achatModel.id!);
    return achats;
  }

  @override
  Widget build(BuildContext context) {
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
                    child: FutureBuilder<AchatModel>(
                        future: dataFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<AchatModel> snapshot) {
                          if (snapshot.hasData) {
                            AchatModel? data = snapshot.data;
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

  Widget pageDetail(AchatModel data) {
    var roleAgent = int.parse(user.role) <= 3;
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
                mainAxisAlignment: (!Responsive.isMobile(context))
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  if (!Responsive.isMobile(context))
                    TitleWidget(
                        title: 'Succursale: ${data.succursale.toUpperCase()}'),
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
                          reporting(data),
                          if (roleAgent)
                            if (double.parse(data.quantity) > 0)
                              transfertProduit(data)
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              // infosEditeurWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(AchatModel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          headerTitle(data),
          const SizedBox(
            height: 20,
          ),
          achatTitle(),
          achats(data),
          const SizedBox(
            height: 20,
          ),
          ventetitle(),
          ventes(data),
          const SizedBox(
            height: 20,
          ),
          benficesTitle(),
          benfices(data),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget headerTitle(AchatModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return SizedBox(
      width: double.infinity,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(data.idProduct,
            style: Responsive.isDesktop(context)
                ? const TextStyle(fontWeight: FontWeight.w600, fontSize: 30)
                : headline6),
      )),
    );
  }

  Widget achatTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'ACHATS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget achats(AchatModel data) {
    var roleAgent = int.parse(user.role) <= 3;

    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    var prixAchatTotal =
        double.parse(data.priceAchatUnit) * double.parse(data.quantityAchat);
    var margeBenifice =
        double.parse(data.prixVenteUnit) - double.parse(data.priceAchatUnit);
    var margeBenificeTotal = margeBenifice * double.parse(data.quantityAchat);

    var margeBenificeRemise =
        double.parse(data.remise) - double.parse(data.priceAchatUnit);
    var margeBenificeTotalRemise =
        margeBenificeRemise * double.parse(data.quantityAchat);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Quantités entrant',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.qtyLivre).toStringAsFixed(2)))} ${data.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (roleAgent)
              Divider(
                color: mainColor,
              ),
            if (roleAgent)
              Row(
                children: [
                  Text('Prix d\'achats unitaire',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text(
                      '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.priceAchatUnit).toStringAsFixed(2)))} \$',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            if (roleAgent)
              Divider(
                color: mainColor,
              ),
            if (roleAgent)
              Row(
                children: [
                  Text('Prix d\'achats total',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text(
                      '${NumberFormat.decimalPattern('fr').format(double.parse(prixAchatTotal.toStringAsFixed(2)))} \$',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyText2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('TVA',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text('${data.tva} %',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
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
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.prixVenteUnit).toStringAsFixed(2)))} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('Prix de Remise',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text('${double.parse(data.remise).toStringAsFixed(2)} \$',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('Qtés pour la remise',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text('${data.qtyRemise} ${data.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyText2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (roleAgent)
              Divider(
                color: mainColor,
              ),
            if (roleAgent)
              const SizedBox(
                height: 20.0,
              ),
            if (roleAgent)
              Responsive.isDesktop(context)
                  ? Row(
                      children: [
                        Text('Marge bénéficiaire unitaire / Remise',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodyText2,
                            overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$ / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeRemise.toStringAsFixed(2)))} \$',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodyText2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marge bénéficiaire unitaire / Remise',
                            textAlign: TextAlign.left,
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodyText2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} \$ / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeRemise.toStringAsFixed(2)))} \$',
                            textAlign: TextAlign.left,
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodyText2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
            if (roleAgent)
              Divider(
                color: mainColor,
              ),
            if (roleAgent)
              Responsive.isDesktop(context)
                  ? Row(
                      children: [
                        Text('Marge bénéficiaire total / Remise',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyText1,
                            overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$ / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotalRemise.toStringAsFixed(2)))} \$',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyText1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marge bénéficiaire total / Remise',
                            textAlign: TextAlign.left,
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyText1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} \$ / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotalRemise.toStringAsFixed(2)))} \$',
                            textAlign: TextAlign.left,
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyText1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
          ],
        ),
      ),
    );
  }

  Widget ventetitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'VENTES',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget ventes(AchatModel data) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    double qtyVendus = 0;
    double prixTotalVendu = 0;

    var ventesQty = venteCartList
        .where((element) {
          String v1 = element.idProductCart;
          String v2 = data.idProduct;
          int date1 = element.created.millisecondsSinceEpoch;
          int date2 = data.created.millisecondsSinceEpoch;
          return v1 == v2 && date2 >= date1;
        })
        .map((e) => double.parse(e.quantityCart))
        .toList();

    for (var item in ventesQty) {
      qtyVendus += item;
    }

    var ventesPrix = venteCartList
        .where((element) {
          var v1 = element.idProductCart;
          var v2 = data.idProduct;
          var date1 = element.created.millisecondsSinceEpoch;
          var date2 = data.created.millisecondsSinceEpoch;
          return v1 == v2 && date2 >= date1;
        })
        .map((e) => double.parse(e.priceTotalCart))
        .toList();

    for (var item in ventesPrix) {
      prixTotalVendu += item;
    }

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantités vendus',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyText2),
              Text('Montant vendus',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyText2),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(qtyVendus.toStringAsFixed(0)))} ${data.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyText1),
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalVendu.toStringAsFixed(2)))} \$',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyText1),
            ],
          ),
        ],
      ),
    ));
  }

  Widget benficesTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'EN STOCKS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget benfices(AchatModel data) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;

    var prixTotalRestante =
        double.parse(data.quantity) * double.parse(data.prixVenteUnit);

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restes des ${data.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyText2),
              Text('Revenues',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyText2),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.quantity).toStringAsFixed(0)))} ${data.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyText1),
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalRestante.toStringAsFixed(2)))} \$',
                  style: Responsive.isDesktop(context)
                      ? TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.green[800])
                      : bodyText1),
            ],
          ),
        ],
      ),
    ));
  }

  Widget transfertProduit(AchatModel data) {
    return IconButton(
      color: Colors.red,
      icon: const Icon(Icons.assistant_direction),
      tooltip: 'Restitution de la quantité en stocks',
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Restituer de la quantité',
              style: TextStyle(color: mainColor)),
          content: const Text(
              'Cette action permet de restitutuer la quantité dans le stock global.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(
                    context, ComMarketingRoutes.comMarketingRestitutionStock,
                    arguments: data);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget reporting(AchatModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrintWidget(onPressed: () async {
          await AchatPdf.generate(data, user, venteCartList);
        })
      ],
    );
  }
}
