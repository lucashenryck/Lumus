import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumus/components/button.dart';
import 'package:lumus/components/textfield.dart';
import 'package:lumus/resources/auth_methods.dart';
import 'package:lumus/util/select_image.dart';
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
  Uint8List? _image;

  @override
  void dispose(){
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _usernameTextController.dispose();
    _confirmPasswordController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
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
      file: _image
    );
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Text(
                    "VAMOS CRIAR UMA CONTA PARA VOCÊ!",
                    style: GoogleFonts.dmSans(
                      color: Color.fromRGBO(229, 210, 131, 1),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
            
                  const SizedBox(height: 25),
            
                  Stack(
                    children: [
                      _image != null ?
                      Container(
                        width: 135, 
                        height: 135,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            width: 1, 
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: MemoryImage(_image!),
                        ),
                      )
                      :
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage('https://static.thenounproject.com/png/354384-200.png'),
                        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Color.fromRGBO(229, 210, 131, 1),
                            size: 35,
                          ),
                        ),
                        bottom: -10,
                        left: 70,
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 25),
            
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
                    text: 'CRIAR CONTA',
                    onTap: signUpUser
                  ),
            
                  const SizedBox(height: 25),
                  //Go to Register Page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Já é um membro?",
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child:Text(
                          "Entrar com sua conta",
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