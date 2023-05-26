import 'package:flutter/material.dart';

class InputsLogin extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final IconData? suffixIconData;
  final ValueChanged<String> onChanged;
  final VoidCallback? onChangedObscure;
  final bool obscureText;
  final TextEditingController textEditingController;
  const InputsLogin(
      {super.key, required this.hintText, required this.iconData, required this.onChanged, this.obscureText = false, this.suffixIconData, required this.textEditingController, this.onChangedObscure});

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: textEditingController,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: Icon(
              iconData,
              color: Colors.blue,
            ),
            suffixIcon: IconButton(
              onPressed: onChangedObscure,
              icon: Icon(suffixIconData),
              color: Colors.blue,
            ),
            hintText: hintText,
            border: InputBorder.none),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}
