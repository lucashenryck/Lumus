import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserLumus> getUserLumusDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('Users').doc(currentUser.uid).get();

    return UserLumus.fromSnap(snap);
  }

  Future<String> signUpUser ({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
  }) async{
    String response = "Some error occurred";
    try{
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && confirmPassword == password){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password   
        );

        UserLumus user = UserLumus(
          id: cred.user!.uid, 
          email: email, 
          username: username, 
          profilePhoto: null, 
          description: null, 
          following: [], 
          followers: []
        );

        await _firestore.collection('Users').doc(cred.user!.uid).set(user.toJson());
        
        await _firestore
        .collection('Users collections')
        .doc(cred.user!.uid)
        .set({});

        List<String> subcollections = [
          'Favorites movies', 
          'Favorites series', 
          'Liked movies', 
          'Liked series', 
          'Watched movies', 
          'Watched series', 
          'Watchlist movies', 
          'Watchlist series'
        ];
        for (String subcollection in subcollections) {
          await _firestore
              .collection('Users collections')
              .doc(cred.user!.uid)
              .set({subcollection: []}, SetOptions(merge: true));
        }

        String customListId = const Uuid().v1();
        await _firestore
        .collection('Custom Lists')
        .doc(customListId)
        .set({});

        response = "success";
      }
    }catch(error){
      response = error.toString();
    }
    return response;
  }

  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String response = "Some error occurred";

    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(
          email: email, 
          password: password
        );
        response = "success";
      }else{
        response = "Por favor, insira todos os campos!";
      }
    } catch (erro){
      response = erro.toString();
    }
    return response;
  }

  Future<String> updateUserProfile({
    String? username,
    String? description,
    Uint8List? file,
  }) async {
    String response = "Some error occurred";
    try {
        Map<String, dynamic> updateData = {};
        if (username != null) {
          updateData['username'] = username;
        }
        if (description != null) {
          updateData['description'] = description;
        }
        if (file != null) {
          String profilePhotoUrl = await StorageMethods().uploadImageToStorage('profile_photo', file);
          updateData['profile_photo_url'] = profilePhotoUrl;
        }
        await _firestore.collection('Users').doc(_auth.currentUser!.uid).update(updateData);

        response = "Sucesso!";
    } catch (error) {
      response = error.toString();
    }
    return response;
  }
}