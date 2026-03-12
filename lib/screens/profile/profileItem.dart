/*
  Scrollable profile items list with a tappable icon dialog demo and
  placeholder rows styled with shadows and colored backgrounds.
*/

import 'package:flutter/material.dart';

class Profileitem extends StatelessWidget {
  const Profileitem({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a scrollable ListView so this widget can be placed inside an Expanded
    // without overflowing when vertical space is limited.
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const Divider(),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.only(left: 10),
          height: 70,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                mouseCursor: SystemMouseCursors.click,
                icon: const Icon(Icons.post_add, color: Colors.black, size: 34),
                onPressed: () {
                  debugPrint('ICON PRESSED !!!!');
                  showDialog(
                    context: context,
                    builder: (_) =>
                        const AlertDialog(content: Text('Icon pressed')),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.only(left: 10),
          height: 70,
          color: Colors.blue,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Profile Item',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 70,
          color: Colors.blue,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Profile Item',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
