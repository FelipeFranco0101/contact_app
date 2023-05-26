import 'package:contact_app/background.dart';
import 'package:contact_app/login/login_screen.dart';
import 'package:contact_app/login/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bienvenido',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SvgPicture.asset(
            'assets/icons/chat.svg',
            height: size.height * 0.45,
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          RoundedButton(
            text: 'Login',
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }));
            },
          ),
          RoundedButton(
              text: 'Sign Up',
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return const SignUp();
                }));
              }),
        ],
      ),
    ));
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;

  const RoundedButton({super.key, required this.text, required this.press});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: SizedBox(
        width: size.height * 0.8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child: FilledButton(
            onPressed: press,
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
