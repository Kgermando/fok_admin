import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/restitution_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/restitution_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/restitutions/components/restitution_pdf.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailRestitution extends StatefulWidget {
  const DetailRestitution({Key? key, required this.restitutionModel})
      : super(key: key);
  final RestitutionModel restitutionModel;

  @override
  State<DetailRestitution> createState() => _DetailRestitutionState();
}

class _DetailRestitutionState extends State<DetailRestitution> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  List<RestitutionModel> restitutionModelList = [];
  List<StocksGlobalMOdel> stockGlobalList = [];
  List<StocksGlobalMOdel> stockGlobalFilter = [];
  bool isChecked = false;

  late Future<RestitutionModel> dataFuture;

  @override
  initState() {
    getData();
    dataFuture = getDataFuture();
    super.initState();
  }

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
    List<StocksGlobalMOdel>? dataStocks = await StockGlobalApi().getAllData();
    setState(() {
      user = data;
      stockGlobalFilter = dataStocks;
    });
  }

  Future<RestitutionModel> getDataFuture() async {
    var achats = await RestitutionApi().getOneData(widget.restitutionModel.id!);
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
                    child: FutureBuilder<RestitutionModel>(
                        future: dataFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<RestitutionModel> snapshot) {
                          if (snapshot.hasData) {
                            RestitutionModel? data = snapshot.data;
                            stockGlobalList = stockGlobalFilter
                                .where((element) =>
                                    element.idProduct == data!.idProduct)
                                .toList();
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

  Widget pageDetail(RestitutionModel data) {
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
                  const TitleWidget(title: "Bon de restitution"),
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
                          PrintWidget(
                            tooltip: 'Imprimer le document',
                            onPressed: () async {
                              await RestitutionPdf.generate(data);
                            },
                          ),
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
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(RestitutionModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          if (data.succursale == user.succursale) accRecepetion(data),
          const SizedBox(height: p20),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Produit :',
                        style:
                            bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.visible),
                    Text(data.idProduct,
                        style: bodyMedium, overflow: TextOverflow.visible),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Produit :',
                          style:
                              bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.visible),
                    ),
                    Expanded(
                      child: Text(data.idProduct,
                          style: bodyMedium, overflow: TextOverflow.visible),
                    ),
                  ],
                ),
          Divider(
            color: mainColor,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Quantité restutué :',
                        style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    Text(
                        '${NumberFormat.decimalPattern('fr').format(double.parse(data.quantity))} ${data.unite}',
                        style: bodyMedium,
                        overflow: TextOverflow.ellipsis),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Quantité restutué :',
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Expanded(
                      child: Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(data.quantity))} ${data.unite}',
                          style: bodyMedium,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  Widget accRecepetion(RestitutionModel data) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    return Card(
      child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Accusé reception:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16)
                        : bodyText1),
                const SizedBox(
                  width: 10.0,
                ),
                (data.accuseReception == 'false')
                    ? (isLoading)
                        ? loadingMini()
                        : checkboxRead(data)
                    : Text('OK',
                        style: Responsive.isDesktop(context)
                            ? const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.green)
                            : bodyText1!.copyWith(color: Colors.green)),
              ],
            ),
          )),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead(RestitutionModel data) {
    isChecked = data.accuseReception == 'true';
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isLoading = true;
        });
        setState(() {
          isChecked = value!;
          transfertProduit(data);
        });
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Future<void> transfertProduit(RestitutionModel data) async {
    var stockId = stockGlobalList.map((e) => e.id).first;
    var achatQty = stockGlobalList.map((e) => e.quantity).first;
    var quantityStockG = stockGlobalList.map((e) => e.quantityAchat).first;
    var pAU = stockGlobalList.map((e) => e.priceAchatUnit).first;
    var pVU = stockGlobalList.map((e) => e.prixVenteUnit).first;
    var uniteStock = stockGlobalList.map((e) => e.unite).first;
    var modeAchat = stockGlobalList.map((e) => e.modeAchat).first;
    var dateAchat = stockGlobalList.map((e) => e.created).first;
    var signatureAchat = stockGlobalList.map((e) => e.signature).first;
    var tvaAchat = stockGlobalList.map((e) => e.tva).first;
    var qtyRavitaillerStock =
        stockGlobalList.map((e) => e.qtyRavitailler).first;

    // Stocks global + qty restitué
    var qtyTransfert = double.parse(achatQty) + double.parse(data.quantity);

    final stocksGlobalMOdel = StocksGlobalMOdel(
        id: stockId,
        idProduct: data.idProduct,
        quantity: qtyTransfert.toString(),
        quantityAchat: quantityStockG,
        priceAchatUnit: pAU,
        prixVenteUnit: pVU,
        unite: uniteStock,
        modeAchat: modeAchat,
        tva: tvaAchat,
        qtyRavitailler: qtyRavitaillerStock,
        signature: signatureAchat,
        created: dateAchat);
    await StockGlobalApi().updateData(stocksGlobalMOdel);

    final restitutionModel = RestitutionModel(
        id: data.id!,
        idProduct: data.idProduct,
        quantity: data.quantity,
        unite: data.unite,
        firstName: data.firstName,
        lastName: data.lastName,
        accuseReception: 'true',
        accuseReceptionFirstName: user.nom.toString(),
        accuseReceptionLastName: user.prenom.toString(),
        role: user.role.toString(),
        succursale: data.succursale,
        signature: user.matricule.toString(),
        created: DateTime.now());
    await RestitutionApi().updateData(restitutionModel).then((value) {
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${restitutionModel.idProduct} transferé!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
