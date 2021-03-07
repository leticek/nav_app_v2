import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InputField extends StatelessWidget {
  const InputField({key, textEditingController, focusNode, onChanged, label})
      : _key = key,
        _textEditingController = textEditingController,
        _focusNode = focusNode,
        _onChanged = onChanged,
        _label = label;

  final Key _key;
  final TextEditingController _textEditingController;
  final FocusNode _focusNode;
  final Function _onChanged;
  final String _label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9.0.h,
      padding: const EdgeInsets.all(5),
      child: TextField(
        key: _key,
        controller: _textEditingController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: _label,
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyan),
          ),
        ),
        style: TextStyle(fontSize: 15.0.sp),
        textInputAction: TextInputAction.next,
        onChanged: (value) async => await _onChanged(value),
      ),
    );
  }
}
