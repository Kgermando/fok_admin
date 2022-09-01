import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/menu_item.dart';

class MenuItems {
  static const List<MenuItemModel> itemsFirst = [
    itemProfile,
    itemHelp,
    itemSettings,
  ];

  static const List<MenuItemModel> itemsSecond = [
    itemLogout,
  ];

  static const itemProfile = MenuItemModel(
    text: 'Profil',
    icon: Icons.person,
  );

  static const itemHelp = MenuItemModel(text: 'Aide', icon: Icons.help);

  static const itemSettings = MenuItemModel(
    text: 'Settings',
    icon: Icons.settings,
  );

  static const itemLogout =
      MenuItemModel(text: 'Déconnexion', icon: Icons.logout);
}
