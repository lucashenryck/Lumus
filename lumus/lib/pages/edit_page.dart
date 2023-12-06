import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/providers/user_provider.dart';
import 'package:lumus/resources/auth_methods.dart';
import 'package:lumus/util/select_image.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Uint8List? _image;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
  }

  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void confirmationAlert(){
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.success,
      text: "Perfil atualizado com sucesso!",
      title: "Sucesso",
      confirmBtnText: "Concluir"
    );
  }

  void errorAlert(){
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.error,
      text: "Algo de errado ocorreu!",
      title: "Erro!",
      confirmBtnText: "Continuar"
    );
  }

  void editProfile(String? username, String? bio, Uint8List? file) async{
    try{
      String response = await AuthMethods().updateUserProfile(
        username: _usernameController.text.trim(),
        description: _descriptionController.text.trim(),
        file: _image
      );
      if(response == "success"){
        confirmationAlert();
      } else {
        errorAlert();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserLumus user = Provider.of<UserProvider>(context).getUserLumus;
    _usernameController.text = user.username;
    _descriptionController.text = user.description ?? "";

    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        title: Text(
          'Editar perfil',
          style: GoogleFonts.dmSans(
            color: Color.fromRGBO(240, 240, 240, 1),
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    _image != null ?
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: MemoryImage(_image!),
                    )
                    :
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                      backgroundImage: NetworkImage(user.profilePhoto ?? 'https://static.thenounproject.com/png/354384-200.png'),
                      radius: 70,
                    ),
                    Positioned(
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          size: 35,
                        ),
                      ),
                      bottom: -10,
                      left: 80,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              buildTextField("Nome de usuário", _usernameController),
              buildTextField("Bio", _descriptionController),
              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => editProfile(
                      _usernameController.text.trim(),
                      _descriptionController.text.trim(),
                      _image
                    ), 
                    child: Text(
                      "Salvar",
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(3, 21, 37, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                  OutlinedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller){
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        style: TextStyle(
          color: Color.fromRGBO(240, 240, 240, 1)
        ),
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 10),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(240, 240, 240, 1)
          ),
          labelStyle: TextStyle(
            color: Color.fromRGBO(240, 240, 240, 1), 
          ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(240, 240, 240, 1), // Change the border color when the TextField is focused
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(240, 240, 240, 1), // Change the border color when the TextField is not focused
          ),
        ),
        ),
      ),
    );
  }
}