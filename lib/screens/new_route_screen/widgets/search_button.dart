import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Function onPressed}) : _onPressed = onPressed;

  final Function _onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.black),
          margin: EdgeInsets.all(10),
          child: IconButton(
            icon: Icon(
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
