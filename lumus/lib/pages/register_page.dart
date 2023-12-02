import 'package:flutter/material.dart';
import 'package:lumus/components/button.dart';
import 'package:lumus/components/textfield.dart';
import 'package:lumus/resources/auth_methods.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key, 
    required this.onTap
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameTextController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _usernameTextController.dispose();
    _confirmPasswordController.dispose();
  }

  void confirmationAlert(){
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.success,
      text: "Conta criada com sucesso!",
      title: "Sucesso",
      confirmBtnText: "Continuar"
    );
  }

  void errorAlert(){
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.error,
      text: "Não foi possível continuar com seu cadastro!",
      title: "Erro!",
      confirmBtnText: "Fechar"
    );
  }

  void signUpUser() async {
    String response = await AuthMethods().signUpUser(
      email: _emailTextController.text.trim(), 
      password: _passwordTextController.text.trim(), 
      username: _usernameTextController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Image.asset(
                  'images/fontbolt.png',
                  width: 250,
                ),

                const SizedBox(height: 25),

                //Register message
                const Text(
                  "Vamos criar uma conta para você!",
                  style: TextStyle(
                    color: Color.fromRGBO(240, 240, 240, 1), 
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                //E-mail textfield
                MyTextField(
                  controller: _emailTextController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                MyTextField(
                  controller: _usernameTextController, 
                  hintText: 'Nome de usuário', 
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                //Password Textfield
                MyTextField(
                  controller: _passwordTextController, 
                  hintText: 'Senha', 
                  obscureText: true,
                ),

                const SizedBox(height: 15),

                //Confirm Password Textfield
                MyTextField(
                  controller: _confirmPasswordController, 
                  hintText: 'Confirmar senha', 
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                //Sign in Button
                MyButton(
                  text: 'Cria conta',
                  onTap: signUpUser
                ),

                const SizedBox(height: 25),
                //Go to Register Page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já é um membro?",
                      style: TextStyle(
                        color: Color.fromRGBO(240, 240, 240, 1),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child:Text(
                        "Entrar com sua conta",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(229, 210, 131, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}