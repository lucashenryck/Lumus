import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/components/textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailTextController = TextEditingController();

  @override
  void dispose(){
    emailTextController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailTextController.text.trim()
      );
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text('Link de redefinição de senha enviado, verifique seu e-mail!'),
          );
        }
      );
    } on FirebaseAuthException catch (e){
      print(e);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
             'Digite seu e-mail que nós enviaremos um link de redefinição de senha!', 
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(240, 240, 240, 1),
                fontSize: 17,
              ),
             textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: MyTextField(
              controller: emailTextController,
              hintText: "Insira seu e-mail",
              obscureText: false,
            ),
          ),
          SizedBox(height: 15),
          MaterialButton(
            onPressed: passwordReset,
            child: Text(
              'Redefinir senha',
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(3, 21, 37, 1),
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            ),
            color: Color.fromRGBO(229, 210, 131, 1),
          ),
        ]
      ),
    );
  }
}