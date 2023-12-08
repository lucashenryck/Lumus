import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/components/custom_list_ui.dart';
import 'package:lumus/resources/firestore_methods.dart';

class CustomListsPage extends StatefulWidget {
  CustomListsPage({super.key, required this.userData});
  Map<dynamic, dynamic> userData;

  @override
  State<CustomListsPage> createState() => _CustomListsPageState();
}

class _CustomListsPageState extends State<CustomListsPage> {
  TextEditingController _listNameController = TextEditingController();
  TextEditingController _listDescriptionController = TextEditingController();
  bool get isOwnProfile => FirebaseAuth.instance.currentUser?.uid == widget.userData['user_id'];

  void createCustomList(
    String userId,
    String creator,
    String name,
    String description,
    String profilePhoto
  ) async {
    try{
      await FirestoreMethods().createCustomList(
        userId, 
        creator, 
        name, 
        description, 
        profilePhoto
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void _showAddDialog(String userId, String username, String profilePhoto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Criar lista personalizada',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(3, 21, 37, 1)
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _listNameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(3, 21, 37, 1)
                  ),
                ),
              ),
              TextField(
                controller: _listDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(3, 21, 37, 1)
                  ),
                  hintText: 'Opcional',
                  hintStyle: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(3, 21, 37, 1)
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancelar',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(3, 21, 37, 1)
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(3, 21, 37, 1)),
              ),
              onPressed: () async {
                createCustomList(
                  userId, 
                  username, 
                  _listNameController.text.trim(), 
                  _listDescriptionController.text.trim(), 
                  profilePhoto
                );
                Navigator.of(context).pop();
                _listNameController.clear(); 
                _listDescriptionController.clear(); 
                setState(() {});
              },              
              child: Text(
                'Criar',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(240, 240, 240, 1)
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        title: Text(
          'Listas personalizadas',
          style: GoogleFonts.dmSans(
            color: Color.fromRGBO(240, 240, 240, 1),
            fontSize: 18,
          ),
        ),
        actions: [
          if (isOwnProfile)
          IconButton(
            onPressed: () => _showAddDialog(widget.userData['user_id'], widget.userData['username'], widget.userData['profile_photo']), 
            icon: Icon(Icons.add)
          ),
        ],
      ),
      body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users collections")
                    .doc(widget.userData['user_id'])
                    .collection("Custom")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro: ' + snapshot.error.toString()),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma lista criada até o momento.',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          color: Color.fromRGBO(240, 240, 240, 1)
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final customList = snapshot.data!.docs[index];
                      return CustomListUi(
                        customList: customList
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}