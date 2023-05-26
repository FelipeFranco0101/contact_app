import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/login/login_screen.dart';
import 'package:contact_app/models/Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'input_commons.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usuarioController = TextEditingController();
  final claveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: size.width * 0.3,
              child: Image.asset('assets/images/signup_top.png'),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: size.width * 0.25,
              child: Image.asset('assets/images/main_bottom.png'),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SIGN UP',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SvgPicture.asset(
                    'assets/icons/signup.svg',
                    height: size.height * 0.35,
                  ),
                  InputsLogin(
                    hintText: 'Usuario',
                    iconData: Icons.person,
                    onChanged: (value) {
                      usuarioController.text = value;
                    },
                    textEditingController: usuarioController,
                  ),
                  InputsLogin(
                      hintText: 'Contraseña',
                      iconData: Icons.lock,
                      onChanged: (value) {
                        claveController.text = value;
                      },
                      obscureText: true,
                      suffixIconData: Icons.visibility,
                      textEditingController: claveController),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: SizedBox(
                      width: size.height * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FilledButton(
                          onPressed: () => _saveUser(),
                          child: const Text('SIGN UP'),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ya tienes una cuenta? ',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return const LoginScreen();
                          }));
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveUser() async {
    var usuario = usuarioController.text;
    var clave = claveController.text;
    var newUser = Auth(id: -1, usuario: usuario, clave: clave);
    await DatabaseHelper.instance.insertUser(newUser);

    usuarioController.text = "";
    claveController.text = "";

    //_showToast("Contacto creado con exito");
  }
}
