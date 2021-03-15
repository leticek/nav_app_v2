import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/models/saved_route.dart';
import 'package:navigation_app/resources/providers.dart';

class DeleteConfirmation extends StatelessWidget {
  const DeleteConfirmation(this.route);

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
          onPressed: () {
            context.read(firestoreProvider).deleteRoute(
                context.read(authServiceProvider).userModel.userId, route.id);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Trasa byla smazána.'),
            ));
            Navigator.of(context).pop();
          },
          child: const Text('Smazat'),
        )
      ],
    );
  }
}
