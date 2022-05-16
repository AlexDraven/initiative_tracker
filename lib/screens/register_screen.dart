import 'package:flutter/material.dart';
import 'package:initiative_tracker/providers/login_form_provider.dart';
import 'package:initiative_tracker/screens/login_screen.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/ui/input_decorations.dart';
import 'package:initiative_tracker/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'character_list_screen.dart';

// ignore: use_key_in_widget_constructors
class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          CardContainer(
              child: Column(children: [
            const SizedBox(height: 10),
            Text('Crear cuenta', style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 30),
            ChangeNotifierProvider(
                create: (_) => LoginFormProvider(), child: const _LoginForm()),
            //const _LoginForm()
          ])),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, LoginScreen.routeName),
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())),
            child: const Text('¿Ya tienes una cuenta?',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                    fontSize: 18)),
          ),
          const SizedBox(height: 50),
        ])),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com',
              labelText: 'Email',
              prefixIcon: Icons.alternate_email_rounded,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String emailPattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(emailPattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no luce como un email';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: '********',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline_rounded,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length > 5)
                  ? null
                  : 'La contraseña no puede estar vacía';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;

                    final String? errorMessage = await authService.createUser(
                        loginForm.firstname,
                        loginForm.lastname,
                        loginForm.email,
                        loginForm.password);

                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(
                          context, CharacterListScreen.routeName);
                    } else {
                      // ignore: avoid_print
                      print(errorMessage);
                      _showToast(context, errorMessage);
                      loginForm.isLoading = false;
                    }

                    //
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(loginForm.isLoading ? 'Entrando...' : "Ingresar",
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

void _showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      action:
          SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
