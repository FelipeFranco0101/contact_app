import 'package:contact_app/contact_home_page.dart';
import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/login/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'input_commons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usuarioController = TextEditingController();
  final claveController = TextEditingController();

  bool showError = false;

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
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'INGRESAR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SvgPicture.asset(
                  'assets/icons/login.svg',
                  height: size.height * 0.20,
                ),
                SizedBox(
                  height: size.height * 0.03,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: SizedBox(
                    width: size.height * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: FilledButton(
                        onPressed: () {
                          validAuth(context);
                        },
                        child: const Text('Ingresar'),
                      ),
                    ),
                  ),
                ),
                if (showError) // Mostrar el mensaje de error solo cuando showError es true
                  const Text(
                    'Usuario o contraseña incorrectos. Intenta nuevamente.',
                    style: TextStyle(color: Colors.red),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No tienes una cuenta? ',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return const SignUp();
                        }));
                      },
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  void validAuth(BuildContext context) async {
    debugPrint('${usuarioController.text} ${claveController.text}');
    await DatabaseHelper.instance
        .auth(usuarioController.text, claveController.text)
        .then(
      (value) {
        if (value != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ContactHomePages(usuario: value.usuario);
          }));
        } else {
          setState(() {
            showError =
                true; // Mostrar el mensaje de error si las credenciales son incorrectas
          });
        }
      },
    );
  }
}
