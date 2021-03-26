import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/providers.dart';
import 'package:navigation_app/resources/utils/route_builder.dart';

class DeleteAccountConfirmation extends StatelessWidget {
  const DeleteAccountConfirmation();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Opravdu si přejete smazat svůj účet?'),
      content: const Text(
          'Při smázání účtu dojde k odhlášení a odstranění všech vašich dat. Operace je NEVRATNÁ.'),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              primary: Colors.black, backgroundColor: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zpět'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.black),
          onPressed: () {
            context.read(authServiceProvider).deleteUser();
            Navigator.pushNamed(context, AppRoutes.auth);
          },
          child: const Text('Smazat účet'),
        )
      ],
    );
  }
}
