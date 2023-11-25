import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumus/components/app_bar_home.dart';
import 'package:lumus/components/drawer.dart';
import 'package:lumus/components/post_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(39, 52, 87, 1),
        appBar: HomeAppBar.appBar(),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                  .collection("Users collections")
                  .doc(currentUser.uid)
                  .collection("User posts")
                  .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        final post = snapshot.data!.docs[index];
                        return PostUI(
                          name: post['name'], 
                          username: post['username'], 
                          content: post['content'], 
                        );
                      }
                    );
                  } else if(snapshot.hasError){
                    return Center(
                      child: Text('Erro: ' + snapshot.error.toString()),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
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