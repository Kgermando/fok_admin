import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.isDesktop(context) ? 400 : double.infinity,
      // height: 500,
      child: Card(
        elevation: 10,
        child: SfCalendar(
          view: CalendarView.month,
        ),
      ),
    );
  }
}
