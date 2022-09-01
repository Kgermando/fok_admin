import 'package:flutter/material.dart';

class AgendaFormWidget extends StatelessWidget {
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const AgendaFormWidget({
    Key? key,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: (number ?? 0).toDouble(),
                  label: 'Niveau d\'importance',
                  min: 0,
                  max: 5,
                  divisions: 5,
                  onChanged: (number) => onChangedNumber(number.toInt()),
                ),
              )
            ],
          ),
          buildTitle(context),
          const SizedBox(height: 8),
          buildDescription(context),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );

  Widget buildTitle(BuildContext context) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: bodyText1,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Titre',
        // hintStyle: TextStyle(color: Colors.black54),
      ),
      validator: (title) => title != null && title.isEmpty
          ? 'La title ne peut pâs être vide'
          : null,
      onChanged: onChangedTitle,
    );
  }

  Widget buildDescription(BuildContext context) {
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return TextFormField(
      maxLines: 10,
      initialValue: description,
      style: bodyText2,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Ecrivez quelque chose...',
        // hintStyle: TextStyle(color: Colors.black54),
      ),
      validator: (title) => title != null && title.isEmpty
          ? 'La description ne peut pâs être vide'
          : null,
      onChanged: onChangedDescription,
    );
  }
}
