import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/components/button.dart';
import 'package:lumus/components/square_tile.dart';
import 'package:lumus/components/textfield.dart';
import 'package:lumus/pages/forgot_password_page.dart';
import 'package:lumus/resources/auth_methods.dart';
import 'package:lumus/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text Editing Controllers
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }

  void loginUser() async {
    String response = await AuthMethods().loginUser(
      email: _emailTextController.text.trim(), 
      password: _passwordTextController.text.trim()
    );
  }

  
  //Error message to user
  void showErrorMessage(String message){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.purple,
          content: SizedBox(
            height: 18,
            child: Center(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void signInAsGuest() async{
    //Show loading circle
    showDialog(
      context: context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    //Try sign in
    try{
      await FirebaseAuth.instance.signInAnonymously(
      ); 
      
      if(context.mounted) Navigator.pop(context);
    }on FirebaseAuthException catch (e){
      //Pop the loading circle
      Navigator.pop(context);

      showErrorMessage(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/fontbolt.png',
                    width: 175,
                  ),
                  const SizedBox(height: 15),
                  //Welcome Back message
                  Text(
                    "QUE BOM TE VER DE NOVO!",
                    style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(229, 210, 131, 1),
                      fontSize: 15,
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
          
                  //Password Textfield
                  MyTextField(
                    controller: _passwordTextController, 
                    hintText: 'Senha', 
                    obscureText: true,
                  ),
          
                  const SizedBox(height: 10),
          
                  //Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return ForgotPasswordPage();
                            },
                            ),
                          );
                        },
                        child: Text(
                          'Esqueceu sua senha?',
                          style: GoogleFonts.dmSans(
                            color: Color.fromRGBO(229, 210, 131, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 30),
          
                  //Sign in Button
                  MyButton(
                    text: 'ENTRAR',
                    onTap: loginUser, 
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: signInAsGuest,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color.fromRGBO(229, 210, 131, 1),
                        ),
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Entrar como visitante",
                          style: GoogleFonts.dmSans(
                            color: Color.fromRGBO(229, 210, 131, 1),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                          
                  const SizedBox(height: 30),
                  
          
                  //Or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Entrar com',
                              style: GoogleFonts.dmSans(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromRGBO(240, 240, 240, 1),
                          )
                        )
                      ],
                    ),
                  ),
          
                  const SizedBox(height: 20),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        imagePath: 'images/google-logo.png',
                        onTap: () => AuthService().signInWithGoogle(),
                        ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  //Go to Register Page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ainda não é membro?",
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child:Text(
                          "Crie uma conta",
                          style: GoogleFonts.dmSans(
                            color: Color.fromRGBO(229, 210, 131, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.bold
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
      ),
    );
  }
}