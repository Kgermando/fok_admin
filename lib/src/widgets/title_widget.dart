import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key, required this.title, this.overflow})
      : super(key: key);
  final String title;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    // final headline6 = Theme.of(context).textTheme.headline6;
    return Padding(
      padding: const EdgeInsets.only(left: p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AutoSizeText(title,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: overflow,
              style: Responsive.isDesktop(context)
                  ? headlineMedium!.copyWith(fontWeight: FontWeight.bold)
                  : const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: p20)
        ],
      ),
    );
  }
}
