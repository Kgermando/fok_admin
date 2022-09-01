import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/widgets/change_theme_button_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> langues = Dropdown().langues;

  String? devise;
  String? langue;

  @override
  void initState() {
    super.initState();
    setState(() {
      langues.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListSettings(
                      icon: Icons.theater_comedy,
                      title: 'Thèmes',
                      options: ChangeThemeButtonWidget()),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListSettings(
                      icon: Icons.language,
                      title: 'Langues',
                      options: langueField(context)),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListSettings(
                      icon: Icons.apps_rounded,
                      title: 'Version de l\'application web',
                      options: getVersionField(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget langueField(BuildContext context) {
    return DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          // labelText: 'Choisissez votre Unité d\'achat',
          labelStyle: TextStyle(),
          contentPadding: EdgeInsets.only(left: 5.0),
        ),
        value: langues.first,
        isExpanded: true,
        items: langues.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (produit) {
          setState(() {
            langue = produit;
          });
        });
  }

  Widget getVersionField(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TextButton(
      child: Text('2.0.1+2', style: headline6),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
            title: Text('FOKAD ADMIN'),
            content: Text('Version: 0.0.1+2 \nDate: 09-3-2022')),
      ),
    );
  }
}

class ListSettings extends StatelessWidget {
  const ListSettings(
      {Key? key,
      required this.icon,
      required this.title,
      required this.options})
      : super(key: key);

  final IconData icon;
  final String title;
  final Widget options;
  // final VoidCallback? tap;

  @override
  Widget build(BuildContext context) {
    final headline5 = Theme.of(context).textTheme.headline5;
    final headline6 = Theme.of(context).textTheme.headline6;
    return ListTile(
      leading: Icon(icon),
      title: Text(title,
          style: Responsive.isDesktop(context) ? headline5 : headline6),
      trailing: SizedBox(width: 100, child: options),
    );
  }
}
