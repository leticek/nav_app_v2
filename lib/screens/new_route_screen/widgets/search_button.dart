import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({void Function() onPressed}) : _onPressed = onPressed;

  final void Function() _onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
          margin: const EdgeInsets.all(10),
          child: IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: _onPressed,
          ),
        )
      ],
    );
  }
}
