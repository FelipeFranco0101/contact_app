import 'package:contact_app/contact_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: size.height,
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/images/main_top.png',
                width: size.width * 0.35,
              )),
          Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/login_bottom.png',
                width: size.width * 0.4,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LOGIN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SvgPicture.asset(
                'assets/icons/login.svg',
                height: size.height * 0.35,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              InputsLogin(
                hintText: 'Usuario',
                iconData: Icons.person,
                onChanged: (value) {},
              ),
              InputsLogin(
                hintText: 'Contraseña',
                iconData: Icons.lock,
                onChanged: (value) {},
                obscureText: true,
                suffixIconData: Icons.visibility,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: SizedBox(
                  width: size.height * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const ContactHomePages();
                        }));
                      },
                      child: const Text('LOGIN'),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No tienes una cuenta? ',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ),
                ],
              )
              /*const TextFieldContainer(
                  child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Contraseña',
                    icon: Icon(
                      Icons.lock,
                      color: Colors.amber,
                    ),
                    suffixIcon: Icon(
                      Icons.visibility,
                      color: Colors.amber,
                    )),
              ))*/
            ],
          )
        ]),
      ),
    );
  }
}

class InputsLogin extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final IconData? suffixIconData;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  const InputsLogin({
    super.key,
    required this.hintText,
    required this.iconData,
    required this.onChanged,
    this.obscureText = false,
    this.suffixIconData,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: Icon(
              iconData,
              color: Colors.blue,
            ),
            suffixIcon: Icon(
              suffixIconData,
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
