import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumus/components/button.dart';
import 'package:lumus/components/textfield.dart';
import 'package:lumus/models/user.dart';

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
  //Text Editing Controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameTextController = TextEditingController();
  final usernameTextController = TextEditingController();

  late UserLumus user;

  //Sign user up method
  Future signUserUp() async{
    //Show loading circle
    showDialog(
      context: context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    //Make sure passwords match
    if(passwordTextController.text != confirmPasswordController.text){
      //Pop the loading circle
      Navigator.pop(context);

      //Show error message, passwords don't match
      showErrorMessage("Senhas não correspondem!");
      return;
    }
  
    //Try creating the user
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text.trim(), 
        password: passwordTextController.text.trim(),
      ).then((firebaseUser) async{
        user.id = firebaseUser.user!.uid;
        user.name = nameTextController.text.trim();

        String username = usernameTextController.text.trim();
        username = username.replaceAll(' ', ''); 
        if (!username.startsWith('@')) {
          username = '@$username'; 
        }
        user.username = username;
        
        user.email = emailTextController.text.trim();
        user.password = passwordTextController.text.trim();
        FirebaseFirestore.instance.collection("Users")
        .doc(firebaseUser.user!.uid)
        .set(user.toMap());
        Navigator.pushReplacementNamed(context, "/");
      });

      //Pop the loading circle
      Navigator.pop(context);

    }on FirebaseAuthException catch (e){

      //Pop the loading circle
      Navigator.pop(context);

      //Show error message
      showErrorMessage(e.code);
    }
  }

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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
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
                  controller: emailTextController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                MyTextField(
                  controller: nameTextController, 
                  hintText: 'Nome', 
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                MyTextField(
                  controller: usernameTextController, 
                  hintText: '@', 
                  obscureText: false,
                  isUsername: true,
                ),

                const SizedBox(height: 15),

                //Password Textfield
                MyTextField(
                  controller: passwordTextController, 
                  hintText: 'Senha', 
                  obscureText: true,
                ),

                const SizedBox(height: 15),

                //Confirm Password Textfield
                MyTextField(
                  controller: confirmPasswordController, 
                  hintText: 'Confirmar senha', 
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                //Sign in Button
                MyButton(
                  text: 'Cria conta',
                  onTap: signUserUp, 
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