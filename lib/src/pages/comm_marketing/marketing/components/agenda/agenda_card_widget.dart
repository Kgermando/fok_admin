import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class AgendaCardWidget extends StatelessWidget {
  const AgendaCardWidget({
    Key? key,
    required this.agendaModel,
    required this.index,
    required this.color,
  }) : super(key: key);

  final AgendaModel agendaModel;
  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index

    // final time = DateFormat("dd.MM.yy HH:mm").format(agendaModel.created);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Ajouté ${timeago.format(agendaModel.created, locale: 'fr_short')}",
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                  ),
                ),
                if (DateTime.now().day == agendaModel.dateRappel.day)
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      shape: BoxShape.circle,
                    ),
                  ),
                if (DateTime.now().day > agendaModel.dateRappel.day)
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      shape: BoxShape.circle,
                    ),
                  )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              agendaModel.title,
              style: Responsive.isDesktop(context)
                  ? const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                  : const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
