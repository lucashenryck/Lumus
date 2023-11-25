import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumus/components/button.dart';
import 'package:lumus/components/square_tile.dart';
import 'package:lumus/components/textfield.dart';
import 'package:lumus/pages/forgot_password_page.dart';
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
final emailTextController = TextEditingController();
final passwordTextController = TextEditingController();

  //Sign user in method
  void signUserIn() async{
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text, 
        password: passwordTextController.text,
      );

      //Pop the loading circle
      if(context.mounted) Navigator.pop(context);
    }on FirebaseAuthException catch (e){

      //Pop the loading circle
      Navigator.pop(context);

      //Show error message
      showErrorMessage(e.code);
    }
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
      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Image.asset(
                    'images/fontbolt.png',
                    width: 275,
                  ),
          
                  const SizedBox(height: 25),
          
                  //Welcome Back message
                  const Text(
                    "Que bom te ver de novo!",
                    style: TextStyle(
                      color: Color.fromRGBO(240, 240, 240, 1), 
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
          
                  const SizedBox(height: 50),
          
                  //E-mail textfield
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'E-mail',
                    obscureText: false,
                    isUsername: false,
                  ),
          
                  const SizedBox(height: 15),
          
                  //Password Textfield
                  MyTextField(
                    controller: passwordTextController, 
                    hintText: 'Senha', 
                    obscureText: true,
                    isUsername: false,
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
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(229, 210, 131, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 30),
          
                  //Sign in Button
                  MyButton(
                    text: 'Entrar',
                    onTap: signUserIn, 
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(229, 210, 131, 1),
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
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Entrar com',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
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
                        style: TextStyle(
                          color: Color.fromRGBO(240, 240, 240, 1),
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child:Text(
                          "Crie uma conta",
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
      ),
    );
  }
}