import 'package:flutter/material.dart';

class LeaveConfirmation extends StatelessWidget {
  const LeaveConfirmation();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Odejít?'),
      content: const Text('Provedené změny nebudou uloženy.'),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              primary: Colors.black, backgroundColor: Colors.white),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Odejít'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Zůstat'),
        )
      ],
    );
  }
}
