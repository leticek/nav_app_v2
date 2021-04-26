import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import '../../../../resources/models/saved_route.dart';
import '../../../../resources/utils/route_builder.dart';

class DeleteConfirmationOffline extends StatelessWidget {
  const DeleteConfirmationOffline(this.route);

  final SavedRoute route;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Smazat trasu?'),
      content: const Text('Po smazání trasy ji není možné dále používat.'),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              primary: Colors.black, backgroundColor: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zpět'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.black),
          onPressed: () async {
            final db = Localstore.instance;
            await db.collection('routes').doc(route.id).delete();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Trasa byla odebrána z lokálního uložiště.'),
            ));
            Navigator.pop(context);
            Navigator.of(context).popAndPushNamed(AppRoutes.myRoutesOffline);
          },
          child: const Text('Smazat'),
        )
      ],
    );
  }
}
