import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        primary: Colors.blue,
      ),
      onPressed: onClicked, icon: 
      const Icon(Icons.date_range), label: Text(text)
    );
  }
  
  
  
  //  ElevatedButton(
        // style: ElevatedButton.styleFrom(
        //   minimumSize: const Size.fromHeight(40),
        //   primary: Colors.grey,
        // ),
  //       child: FittedBox(
  //         child: Text(
  //           text,
  //           style: const TextStyle(fontSize: 20, color: Colors.black),
  //         ),
  //       ),
  //       onPressed: onClicked,
  //     );
}
