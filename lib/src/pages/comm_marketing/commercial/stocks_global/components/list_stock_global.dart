import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class ListStockGlobal extends StatelessWidget {
  const ListStockGlobal(
      {Key? key, required this.stocksGlobalMOdel, required this.role})
      : super(key: key);
  final StocksGlobalMOdel stocksGlobalMOdel;
  final String role;

  @override
  Widget build(BuildContext context) {
    var restesenPourcent = (double.parse(stocksGlobalMOdel.quantity) * 100) /
        double.parse(stocksGlobalMOdel.quantityAchat);
    int roleAgent = int.parse(role);
    return GestureDetector(
      onTap: () {
        if (roleAgent <= 3) {
          Navigator.pushNamed(
              context, ComMarketingRoutes.comMarketingStockGlobalDetail,
              arguments: stocksGlobalMOdel);
        }
      },
      child: Card(
          elevation: 10,
          color: colorQty(),
          child: ListTile(
            dense: true,
            leading: const Icon(
              Icons.shopping_basket_sharp,
              color: Colors.black,
              size: 40.0,
            ),
            title: Text(stocksGlobalMOdel.idProduct,
                overflow: TextOverflow.clip,
                style: Responsive.isDesktop(context)
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black)
                    : const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
            subtitle: Text(
              'Stock: ${double.parse(stocksGlobalMOdel.quantity).toStringAsFixed(0)} ${stocksGlobalMOdel.unite}',
              overflow: TextOverflow.clip,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black),
            ),
            trailing: Text('${restesenPourcent.toStringAsFixed(2)} %',
                style: Responsive.isDesktop(context)
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black)
                    : const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black)),
          )),
    );
  }

  colorQty() {
    var color50 = double.parse(stocksGlobalMOdel.quantityAchat) / 2;
    var color40 = double.parse(stocksGlobalMOdel.quantityAchat) / 4;
    var color8 = color40 / 4;

    var color35 = color40 + color8;
    var color75 = color50 + color40;

    if (double.parse(stocksGlobalMOdel.quantityAchat) ==
        double.parse(stocksGlobalMOdel.quantity)) {
      return Colors.green[400];
    } else if (double.parse(stocksGlobalMOdel.quantity) >= color75) {
      return Colors.green[300];
    } else if (double.parse(stocksGlobalMOdel.quantity) >= color50) {
      return Colors.teal[200];
    } else if (double.parse(stocksGlobalMOdel.quantity) >= color50) {
      return Colors.teal[100];
    } else if (double.parse(stocksGlobalMOdel.quantity) >= color35) {
      return Colors.yellow[200];
    } else if (double.parse(stocksGlobalMOdel.quantity) >= color40) {
      return Colors.orange[200];
    } else if (double.parse(stocksGlobalMOdel.quantity) >= color8) {
      return Colors.yellow;
    } else if (double.parse(stocksGlobalMOdel.quantity) >= 0.0) {
      return Colors.red[300];
    } else {
      return Colors.red[400];
    }
  }
}
