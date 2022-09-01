import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/cart_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailCart extends StatefulWidget {
  const DetailCart({Key? key}) : super(key: key);

  @override
  State<DetailCart> createState() => _DetailCartState();
}

class _DetailCartState extends State<DetailCart> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  initState() {
    getData();
    super.initState();
  }

  List<AchatModel> listAchat = [];
  Future<void> getData() async {
    List<AchatModel>? dataList = await AchatApi().getAllData();

    if (!mounted) return;
    setState(() {
      listAchat = dataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    CartModel cart = ModalRoute.of(context)!.settings.arguments as CartModel;
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
                                  title: Responsive.isDesktop(context)
                                      ? 'Commercial & Marketing'
                                      : 'Comm. & Mark.',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer()),
                            ),
                          ],
                        ),
                        Expanded(
                            child:
                                SingleChildScrollView(child: pageDetail(cart)))
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(CartModel cart) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
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
                  const TitleWidget(title: 'Votre panier'),
                  Column(
                    children: [
                      PrintWidget(
                          tooltip: 'Imprimer le document', onPressed: () {}),
                      SelectableText(
                          DateFormat("dd-MM-yy HH:mm").format(cart.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(cart),
              Divider(
                color: mainColor,
              ),
              const SizedBox(height: p10),
              total(cart),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(CartModel cart) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          const SizedBox(height: p30),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Produit :',
                    textAlign: TextAlign.start,
                    style: bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(cart.idProductCart,
                    textAlign: TextAlign.start, style: bodyLarge),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Quantités :',
                    textAlign: TextAlign.start,
                    style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(cart.quantityCart))} ${cart.unite}',
                    textAlign: TextAlign.start,
                    style: bodyLarge),
              ),
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Prix unitaire :',
                    textAlign: TextAlign.start,
                    style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              ),
              (double.parse(cart.quantityCart) >= double.parse(cart.qtyRemise))
                  ? Expanded(
                      flex: 3,
                      child: Text(
                          '${NumberFormat.decimalPattern('fr').format(double.parse(cart.remise))} x ${NumberFormat.decimalPattern('fr').format(double.parse(cart.quantityCart))} ${cart.unite}',
                          textAlign: TextAlign.start,
                          style: bodyLarge),
                    )
                  : Expanded(
                      flex: 3,
                      child: Text(
                        '${NumberFormat.decimalPattern('fr').format(double.parse(cart.priceCart))} x ${NumberFormat.decimalPattern('fr').format(double.parse(cart.quantityCart))} ${cart.unite}',
                        textAlign: TextAlign.start,
                        style: bodyLarge,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget total(CartModel cart) {
    double sum = 0.0;
    var qtyRemise = double.parse(cart.qtyRemise);
    var quantityCart = double.parse(cart.quantityCart);

    if (quantityCart >= qtyRemise) {
      sum = double.parse(cart.quantityCart) * double.parse(cart.remise);
    } else {
      sum = double.parse(cart.quantityCart) * double.parse(cart.priceCart);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Montant à payé',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    overflow: TextOverflow.ellipsis),
                Text('${NumberFormat.decimalPattern('fr').format(sum)} \$',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red.shade700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  updateAchat(CartModel cart) async {
    final achatQtyList =
        listAchat.where((e) => e.idProduct == cart.idProductCart);

    final achatQty = achatQtyList
        .map((e) => double.parse(e.quantity) + double.parse(cart.quantityCart))
        .first;

    final achatIdProduct = achatQtyList.map((e) => e.idProduct).first;
    final achatQuantityAchat = achatQtyList.map((e) => e.quantityAchat).first;
    final achatAchatUnit = achatQtyList.map((e) => e.priceAchatUnit).first;
    final achatPrixVenteUnit = achatQtyList.map((e) => e.prixVenteUnit).first;
    final achatUnite = achatQtyList.map((e) => e.unite).first;
    final achatId = achatQtyList.map((e) => e.id).first;
    final achattva = achatQtyList.map((e) => e.tva).first;
    final achatRemise = achatQtyList.map((e) => e.remise).first;
    final achatQtyRemise = achatQtyList.map((e) => e.qtyRemise).first;
    final achatQtyLivre = achatQtyList.map((e) => e.qtyLivre).first;
    final achatSuccursale = achatQtyList.map((e) => e.succursale).first;
    final achatSignature = achatQtyList.map((e) => e.signature).first;
    final achatCreated = achatQtyList.map((e) => e.created).first;

    final achatModel = AchatModel(
        id: achatId!,
        idProduct: achatIdProduct,
        quantity: achatQty.toString(),
        quantityAchat: achatQuantityAchat,
        priceAchatUnit: achatAchatUnit,
        prixVenteUnit: achatPrixVenteUnit,
        unite: achatUnite,
        tva: achattva,
        remise: achatRemise,
        qtyRemise: achatQtyRemise,
        qtyLivre: achatQtyLivre,
        succursale: achatSuccursale,
        signature: achatSignature,
        created: achatCreated);

    await AchatApi().updateData(achatModel);
    await CartApi()
        .deleteData(cart.id!)
        .then((value) => Navigator.pop(context));
  }
}
