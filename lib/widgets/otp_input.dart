import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput({required this.controller, this.autoFocus = false, super.key});

  void _replaceNumber(context) {
    controller.text = controller.text.substring(1);
    FocusScope.of(context).nextFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        maxLength: 2,
        onTap: () => controller.selection =
            TextSelection.collapsed(offset: controller.text.length),
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) => {
          if (value.length > 1)
            _replaceNumber(context)
          else if (value.isNotEmpty)
            FocusScope.of(context).nextFocus()
        },
      ),
    );
  }
}
