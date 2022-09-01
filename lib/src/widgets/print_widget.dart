import 'package:flutter/material.dart';

class PrintWidget extends StatelessWidget {
  const PrintWidget({Key? key, required this.onPressed, this.tooltip}) : super(key: key);
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          tooltip: 'Imprimer le document',
          onPressed: onPressed, 
          icon: const Icon(Icons.print)
        )
      ],
    );
  }
}
