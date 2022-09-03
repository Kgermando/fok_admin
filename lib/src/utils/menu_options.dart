import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/helpers/user_shared_pref.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/menu_items.dart';

class MenuOptions {
  PopupMenuItem<MenuItemModel> buildItem(MenuItemModel item) => PopupMenuItem(
      value: item,
      child: Row(
        children: [
          Icon(item.icon, size: 20),
          const SizedBox(width: 12),
          Text(item.text)
        ],
      ));

  void onSelected(BuildContext context, MenuItemModel item) async {
    switch (item) {
      case MenuItems.itemProfile:
        Navigator.pushNamed(context, UserRoutes.profile);
        break;

      case MenuItems.itemHelp:
        Navigator.pushNamed(context, UserRoutes.helps);
        break;

      case MenuItems.itemSettings:
        Navigator.pushNamed(context, UserRoutes.settings);
        break;

      case MenuItems.itemLogout:
        // Remove stockage jwt here.
        await AuthApi().getUserId().then((user) async {
          final userModel = UserModel(
              id: user.id,
              nom: user.nom,
              prenom: user.prenom,
              email: user.email,
              telephone: user.telephone,
              matricule: user.matricule,
              departement: user.departement,
              servicesAffectation: user.servicesAffectation,
              fonctionOccupe: user.fonctionOccupe,
              role: user.role,
              isOnline: 'false',
              createdAt: user.createdAt,
              passwordHash: user.passwordHash,
              succursale: user.succursale);
          await UserApi().updateData(userModel);
          await AuthApi().logout().then((value) {
            UserSharedPref().removeIdToken();
            UserSharedPref().removeAccessToken();
            UserSharedPref().removeRefreshToken();
            // Phoenix.rebirth(context);Phoenix.rebirth(context); // Il genere un probleme de deconnection
            Navigator.pushNamed(context, UserRoutes.logout);
          });
        });
    }
  }
}
