import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/components/app_bar_home.dart';
import 'package:lumus/components/post_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        appBar: HomeAppBar.appBar(),
        body: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Posts")
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
                  if (currentUser == null || currentUser.isAnonymous) {
                    // User is anonymous, show a message
                    return Center(
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
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('NADA ATÉ O MOMENTO!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data!.docs[index];
                      return PostUI(
                        post: post
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}