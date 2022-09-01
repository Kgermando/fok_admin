import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/cart_api.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/cart_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:intl/intl.dart';

class AchatItemWidget extends StatefulWidget {
  const AchatItemWidget({Key? key, required this.achat}) : super(key: key);
  final AchatModel achat;

  @override
  State<AchatItemWidget> createState() => _AchatItemWidgetState();
}

class _AchatItemWidgetState extends State<AchatItemWidget> {
  final _form = GlobalKey<FormState>();

  TextEditingController controllerQuantityCart = TextEditingController();

  // Après ajout au panier le produit quite la liste
  bool isActive = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Visibility(
      visible: isActive,
      child: Responsive.isDesktop(context)
          ? Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.shopping_basket_sharp,
                        color: Colors.green.shade700, size: 40.0),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width / 2,
                            child: Text(
                              widget.achat.idProduct,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width / 2,
                            child: Text(
                              'Stock: ${NumberFormat.decimalPattern('fr').format(double.parse(widget.achat.quantity))} ${widget.achat.unite} / ${NumberFormat.decimalPattern('fr').format(double.parse(widget.achat.prixVenteUnit))} \$',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.green.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Form(
                          key: _form,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(child: qtyField()),
                              Expanded(child: onChanged())
                            ],
                          ),
                        ))
                  ],
                ),
              ))
          : Card(
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.shopping_basket_sharp,
                      color: Colors.green.shade700, size: 40.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width / 2,
                              child: AutoSizeText(
                                widget.achat.idProduct,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                'Stock: ${NumberFormat.decimalPattern('fr').format(double.parse(widget.achat.quantity))} ${widget.achat.unite} / ${NumberFormat.decimalPattern('fr').format(double.parse(widget.achat.prixVenteUnit))} \$',
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                    color: Colors.green.shade700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Form(
                        key: _form,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(child: qtyField()),
                            Expanded(child: onChanged())
                          ],
                        ),
                      ))
                ],
              ),
            ),
    );
  }

  Widget qtyField() {
    return SizedBox(
      width: Responsive.isDesktop(context) ? 100 : 50,
      height: 40,
      child: TextFormField(
        style: Responsive.isDesktop(context)
            ? const TextStyle(
                fontSize: 16,
              )
            : const TextStyle(
                fontSize: 12,
              ),
        controller: controllerQuantityCart,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: const InputDecoration(
          hintText: 'Qtés...',
        ),
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Check Qtés';
          } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
            return 'chiffres obligatoire';
          } else if (double.parse(value) >
              double.parse(widget.achat.quantity)) {
            return 'Qtés insuffisantes';
          } else {
            return null;
          }
        },
        onSaved: (value) => controllerQuantityCart.text,
      ),
    );
  }

  Widget onChanged() {
    return IconButton(
        tooltip: 'Ajoutez au panier',
        iconSize: Responsive.isDesktop(context) ? 24.0 : 18.0,
        onPressed: () {
          if (_form.currentState!.validate()) {
            addCart();
            updateAchat();
            setState(() {
              isActive = !isActive;
            });
          }
        },
        icon:
            Icon(Icons.add_shopping_cart_sharp, color: Colors.green.shade700));
  }

  Future addCart() async {
    final cartModel = CartModel(
        idProductCart: widget.achat.idProduct,
        quantityCart: controllerQuantityCart.text,
        priceCart: widget.achat.prixVenteUnit,
        priceAchatUnit: widget.achat.priceAchatUnit,
        unite: widget.achat.unite,
        tva: widget.achat.tva,
        remise: widget.achat.remise,
        qtyRemise: widget.achat.qtyRemise,
        succursale: user!.succursale,
        signature: user!.matricule,
        created: DateTime.now());
    await CartApi().insertData(cartModel);
    // Navigator.of(context).pop();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${cartModel.idProductCart} ajouté!"),
      backgroundColor: Colors.green.shade700,
    ));
  }

  updateAchat() async {
    var qty = double.parse(widget.achat.quantity) -
        double.parse(controllerQuantityCart.text);
    final achatModel = AchatModel(
        id: widget.achat.id!,
        idProduct: widget.achat.idProduct,
        quantity: qty.toString(),
        quantityAchat: widget.achat.quantityAchat,
        priceAchatUnit: widget.achat.priceAchatUnit,
        prixVenteUnit: widget.achat.prixVenteUnit,
        unite: widget.achat.unite,
        tva: widget.achat.tva,
        remise: widget.achat.remise,
        qtyRemise: widget.achat.qtyRemise,
        qtyLivre: widget.achat.qtyLivre,
        succursale: widget.achat.succursale,
        signature: widget.achat.signature,
        created: DateTime.now());
    await AchatApi().updateData(achatModel).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Quantité mise à jour avec succès!"),
        backgroundColor: Colors.green.shade700,
      ));
    });
  }
}
