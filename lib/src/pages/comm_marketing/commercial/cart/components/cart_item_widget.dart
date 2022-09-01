import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/cart_api.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:intl/intl.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({Key? key, required this.cart}) : super(key: key);
  final CartModel cart;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  bool isloading = false;

  TextEditingController controllerQuantityCart = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<AchatModel> listAchat = [];

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
    List<AchatModel>? dataList = await AchatApi().getAllData();

    if (!mounted) return;
    setState(() {
      user = userModel;
      listAchat = dataList;
    });
  }

  @override
  void dispose() {
    controllerQuantityCart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var role = int.parse(user.role) <= 3;
    double sum = 0;
    var qtyRemise = double.parse(widget.cart.qtyRemise);
    var quantity = double.parse(widget.cart.quantityCart);
    if (quantity >= qtyRemise) {
      sum = double.parse(widget.cart.quantityCart) *
          double.parse(widget.cart.remise);
    } else {
      sum = double.parse(widget.cart.quantityCart) *
          double.parse(widget.cart.priceCart);
    }

    return SafeArea(
        child: Responsive.isDesktop(context)
            ? Card(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, ComMarketingRoutes.comMarketingcartDetail,
                        arguments: widget.cart);
                  },
                  child: ListTile(
                    leading: const Icon(
                      Icons.shopping_cart,
                      size: 30.0,
                    ),
                    title: Text(widget.cart.idProductCart,
                        style: Theme.of(context).textTheme.bodyText1),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: (double.parse(widget.cart.quantityCart) >=
                                  double.parse(widget.cart.qtyRemise))
                              ? Text(
                                  '${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.remise))} x ${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.quantityCart))} ${widget.cart.unite}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                )
                              : Text(
                                  '${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.priceCart))} x ${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.quantityCart))} ${widget.cart.unite}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                        ),
                      ],
                    ),
                    trailing: ConstrainedBox(
                      constraints: const BoxConstraints.expand(width: 200),
                      child: Row(
                        children: [
                          Text(
                              'Total: ${NumberFormat.decimalPattern('fr').format(sum)} \$',
                              style: Theme.of(context).textTheme.bodyText1),
                          onCancel(),
                        ],
                      ),
                    ),
                    dense: true,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                ),
              )
            : Card(
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart,
                        color: Colors.teal, size: 40.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cart.idProductCart,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        (double.parse(widget.cart.quantityCart) >
                                double.parse(widget.cart.qtyRemise))
                            ? Text(
                                '${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.priceCart))} x ${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.quantityCart))} ${widget.cart.unite}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                    color: Colors.teal),
                              )
                            : Text(
                                '${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.priceCart))} x ${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.quantityCart))} ${widget.cart.unite}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                    color: Colors.teal),
                              ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                        constraints: const BoxConstraints(minWidth: 100),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                '${NumberFormat.decimalPattern('fr').format(sum)} \$',
                                style: Theme.of(context).textTheme.bodyText1),
                            onCancel(),
                          ],
                        ))
                  ],
                ),
              ));
  }

  Widget onCancel() {
    return IconButton(
        tooltip: 'Annuler',
        onPressed: () {
          setState(() {
            isloading = true;
          });
          setState(() {
            updateAchat();
          });
          setState(() {
            isloading = false;
          });
        },
        icon: (isloading)
            ? loadingMini()
            : const Icon(Icons.cancel, color: Colors.red));
  }

  updateAchat() async {
    final achatQtyList =
        listAchat.where((e) => e.idProduct == widget.cart.idProductCart);

    final achatQty = achatQtyList
        .map((e) =>
            double.parse(e.quantity) + double.parse(widget.cart.quantityCart))
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
        .deleteData(widget.cart.id!)
        .then((value) => Navigator.pop(context));
  }
}
