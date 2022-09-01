import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:flutter/material.dart';

class UpdateNav extends StatelessWidget {
  const UpdateNav({Key? key, required this.pageCurrente, required this.user})
      : super(key: key);
  final String pageCurrente;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return DrawerWidget(
        selected: pageCurrente == UpdateRoutes.updatePage,
        icon: Icons.update,
        sizeIcon: 20.0,
        title: 'Update',
        style: bodyLarge!,
        onTap: () {
          Navigator.pushNamed(context, UpdateRoutes.updatePage);
        });
  }
}
