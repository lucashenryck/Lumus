import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/pages/searching%20for%20create/searching_page_for_post_.dart';
import 'package:lumus/pages/searching%20for%20create/searching_page_for_review.dart';
import 'package:lumus/providers/user_provider.dart';
import 'package:lumus/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _contentController = TextEditingController();
  
  void sendPost(
    String userId, 
    String username, 
    String? profilePhoto
  ) async {
    try{
      String response = await FirestoreMethods().sendPost(
        _contentController.text, 
        userId, 
        username, 
        profilePhoto
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

  void confirmationAlert(){
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.success,
      text: "Post publicado!",
      title: "Sucesso!",
      confirmBtnText: "Concluir",
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      confirmBtnColor: Color.fromRGBO(3, 21, 37, 1),
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

  @override
  void dispose(){
    super.dispose();
    _contentController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final UserLumus user = Provider.of<UserProvider>(context).getUserLumus;
    final User? currentUser = FirebaseAuth.instance.currentUser!;
    bool isAnonymous = currentUser!.isAnonymous;
    return !isAnonymous ? Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
            child: ElevatedButton(
              onPressed: () => sendPost(
                user.id, 
                user.username, 
                user.profilePhoto
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Publicar',
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(3, 21, 37, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                              return SearchingForPostPage();
                          }),
                        );
                      }, 
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color.fromRGBO(240, 240, 240, 1)), // Change the color here
                      ),
                      child: Text(
                        'É um post sobre algo?',
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                              return SearchingForReviewPage();
                          }),
                        );
                      }, 
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color.fromRGBO(240, 240, 240, 1)), // Change the color here
                      ),
                      child: Text(
                        'É uma review sobre algo?',
                        style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: TextFormField(
                controller: _contentController,
                minLines: 1,
                maxLines: 500,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(240, 240, 240, 1), // Change the color of the typed text
                  textStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
                decoration: InputDecoration(
                  hintText: 'O que você deseja postar?',
                  hintStyle: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    textStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.transparent,  // Change the color of the border for the normal state
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.transparent,  // Change the color of the border for the focused state
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    )
    :
    Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Você está logado como anônimo. Nada aqui para mostrar.',
            style: GoogleFonts.dmSans(
              color: Color.fromRGBO(240, 240, 240, 1),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}