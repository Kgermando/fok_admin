import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListMails extends StatefulWidget {
  const ListMails(
      {Key? key,
      required this.fullName,
      required this.email,
      // required this.cc,
      required this.objet,
      required this.read,
      required this.dateSend, required this.color})
      : super(key: key);

  final String fullName;
  final String email;
  // final List cc;
  final String objet;
  final String read;
  final DateTime dateSend;
  final Color color;

  @override
  State<ListMails> createState() => _ListMailsState();
}

class _ListMailsState extends State<ListMails> {
  @override
  Widget build(BuildContext context) {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    final String firstLettter = widget.fullName[0];

    return Material(
        color: (widget.read == 'true') ? Colors.white : Colors.amber.shade200,
        child: ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: CircleAvatar(
              backgroundColor: Colors.white38,
              child: AutoSizeText(
                firstLettter.toUpperCase(),
                style: headlineMedium!.copyWith(color: widget.color),
                maxLines: 1,
              ),
            ),
          ),
          title: AutoSizeText(widget.fullName, maxLines: 1),
          subtitle: AutoSizeText(widget.objet, maxLines: 2),
          selectedTileColor: Colors.amberAccent,
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                  timeago.format(widget.dateSend, locale: 'fr_short'),
                  textAlign: TextAlign.start),
              (widget.read == 'false')
                  ? const Icon(Icons.mail)
                  : const Icon(Icons.mark_email_read)
            ],
          ),
        ));
  }
}
