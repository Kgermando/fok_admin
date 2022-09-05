import 'package:fokad_admin/src/pages/comm_marketing/plateforms/desktop/succursale_approbation_desktop.dart';
import 'package:fokad_admin/src/pages/comm_marketing/plateforms/mobile/succursale_approbation_mobile.dart';
import 'package:fokad_admin/src/pages/comm_marketing/plateforms/tablet/succursale_approbation_tablet.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/creance_facture_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/gain_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_cart_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/creance_cart_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/gain_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/stats_succusale.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailSuccursale extends StatefulWidget {
  const DetailSuccursale({Key? key}) : super(key: key);

  @override
  State<DetailSuccursale> createState() => _DetailSuccursaleState();
}

class _DetailSuccursaleState extends State<DetailSuccursale> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  bool isLoadingDelete = false;

  DateTimeRange? dateRange;

  String getPlageDate() {
    if (dateRange == null) {
      return 'Filtre par plage de date';
    } else {
      return '${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}';
    }
  }

  // Approbations
  String approbationDG = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();

  @override
  void initState() {
    getData();
    getPlageDate();
    super.initState();
  }

  @override
  void dispose() {
    motifDGController.dispose();
    motifDDController.dispose();
    super.dispose();
  }

  // Stocks par succursale
  List<AchatModel> achatList = [];
  // Ventes par succursale
  List<VenteCartModel> venteList = [];
  // Créance par succursale
  List<CreanceCartModel> creanceList = [];
  // Gain par succursale
  List<GainModel> gainList = [];

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
    UserModel data = await AuthApi().getUserId();
    List<AchatModel>? dataAchat = await AchatApi().getAllData();
    List<CreanceCartModel>? dataCreance =
        await CreanceFactureApi().getAllData();
    List<VenteCartModel>? dataVente = await VenteCartApi().getAllData();
    List<GainModel>? dataGain = await GainApi().getAllData();
    setState(() {
      user = data;
      achatList = dataAchat;
      venteList = dataVente;
      creanceList = dataCreance;
      gainList = dataGain;
    });
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;
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
                    child: FutureBuilder<SuccursaleModel>(
                        future: SuccursaleApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<SuccursaleModel> snapshot) {
                          if (snapshot.hasData) {
                            SuccursaleModel? data = snapshot.data;
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
                                  child: Column(
                                    children: [
                                      pageDetail(data!),
                                      const SizedBox(height: p10),
                                      // LayoutBuilder(
                                      //     builder: (context, constraints) {
                                      //   if (constraints.maxWidth >= 1100) {
                                      //     return SuccursaleApprobationDesktop(
                                      //         user: user,
                                      //         succursaleModel: data);
                                      //   } else if (constraints.maxWidth <
                                      //           1100 &&
                                      //       constraints.maxWidth >= 650) {
                                      //     return SuccursaleApprobationTablet(
                                      //         user: user,
                                      //         succursaleModel: data);
                                      //   } else {
                                      //     return SuccursaleApprobationMobile(
                                      //         user: user,
                                      //         succursaleModel: data);
                                      //   }
                                      // })
                                    ],
                                  ),
                                ))
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

  Widget pageDetail(SuccursaleModel data) {
    int userRole = int.parse(user.role);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TitleWidget(title: "Succursale"),
                  Row(
                    children: [
                      IconButton(
                          color: Colors.purple,
                          onPressed: () {
                            Navigator.pushNamed(context,
                                ComMarketingRoutes.comMarketingSuccursaleUpdate,
                                arguments: data);
                          },
                          icon: const Icon(Icons.edit)),
                      if (userRole <= 2) deleteButton(data),
                      const SizedBox(width: p10),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget deleteButton(SuccursaleModel data) {
    return IconButton(
      color: Colors.red.shade700,
      icon: const Icon(Icons.delete),
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?'),
          content:
              const Text('Cette action permet de supprimer définitivement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoadingDelete = true;
                });
                await SuccursaleApi().deleteData(data.id!).then((value) {
                  setState(() {
                    isLoadingDelete = false;
                  });
                  Navigator.pop(context, 'true');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("${data.name} vient d'être supprimé!"),
                    backgroundColor: Colors.red[700],
                  ));
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(SuccursaleModel data) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerTitle(data),
          StatsSuccursale(succursaleModel: data),
          const SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }

  Widget headerTitle(SuccursaleModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    var dataAchatList =
        achatList.where((element) => element.succursale == data.name).toList();
    // var dataCreanceList = creanceList.where((element) => element.succursale == data.name).toList();
    // var dataVenteList = venteList.where((element) => element.succursale == data.name).toList();
    // var dataGainList = gainList.where((element) => element.succursale == data.name).toList();

    // Achat global
    double sumAchat = 0;
    var dataAchat = dataAchatList
        .map((e) => double.parse(e.priceAchatUnit) * double.parse(e.quantity))
        .toList();
    for (var data in dataAchat) {
      sumAchat += data;
    }

    // Revenues
    double sumAchatRevenue = 0;
    var dataAchatRevenue = dataAchatList
        .map((e) => double.parse(e.prixVenteUnit) * double.parse(e.quantity))
        .toList();

    for (var data in dataAchatRevenue) {
      sumAchatRevenue += data;
    }

    // Marge beneficaires
    double sumAchatMarge = 0;
    var dataAchatMarge = dataAchatList
        .map((e) =>
            (double.parse(e.prixVenteUnit) - double.parse(e.priceAchatUnit)) *
            double.parse(e.quantity))
        .toList();
    for (var data in dataAchatMarge) {
      sumAchatMarge += data;
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Responsive.isMobile(context)
                ? Column(
                    children: [
                      Text('Nom :',
                          textAlign: TextAlign.start,
                          style: bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      SelectableText(data.name,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text('Nom :',
                            textAlign: TextAlign.start,
                            style: bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: SelectableText(data.name,
                            textAlign: TextAlign.start, style: bodyMedium),
                      )
                    ],
                  ),
            Divider(color: mainColor),
            Responsive.isMobile(context)
                ? Column(
                    children: [
                      Text('Province :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      SelectableText(data.province,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text('Province :',
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: SelectableText(data.province,
                            textAlign: TextAlign.start, style: bodyMedium),
                      )
                    ],
                  ),
            Divider(color: mainColor),
            Responsive.isMobile(context)
                ? Column(
                    children: [
                      Text('Adresse :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      SelectableText(data.adresse,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text('Adresse :',
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: SelectableText(data.adresse,
                            textAlign: TextAlign.start, style: bodyMedium),
                      )
                    ],
                  ),
            Divider(color: mainColor),
            Responsive.isMobile(context)
                ? Column(
                    children: [
                      Text('Investissement :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      SelectableText(
                          "${NumberFormat.decimalPattern('fr').format(sumAchat)} \$",
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(color: Colors.purple)),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text('Investissement :',
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: SelectableText(
                            "${NumberFormat.decimalPattern('fr').format(sumAchat)} \$",
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(color: Colors.purple)),
                      )
                    ],
                  ),
            Divider(color: mainColor),
            Responsive.isMobile(context)
                ? Column(
                    children: [
                      Text('Revenus attendus :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      SelectableText(
                          "${NumberFormat.decimalPattern('fr').format(sumAchatRevenue)} \$",
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(color: Colors.blue)),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text('Revenus attendus :',
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: SelectableText(
                            "${NumberFormat.decimalPattern('fr').format(sumAchatRevenue)} \$",
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(color: Colors.blue)),
                      )
                    ],
                  ),
            Divider(color: mainColor),
            Responsive.isMobile(context)
                ? Column(
                    children: [
                      Text('Marge bénéficiaires :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      SelectableText(
                          "${NumberFormat.decimalPattern('fr').format(sumAchatMarge)} \$",
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(color: Colors.green)),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text('Marge bénéficiaires :',
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: SelectableText(
                            "${NumberFormat.decimalPattern('fr').format(sumAchatMarge)} \$",
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(color: Colors.green)),
                      )
                    ],
                  ),
          ],
        ),
      )),
    );
  }
}
