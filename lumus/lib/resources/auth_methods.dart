import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/resources/storage_methods.dart';

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
    required String username,
    required Uint8List? file
  }) async{
    String response = "Some error occurred";
    try{
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && (file != null || file == null)){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password   
        );

        String? profilePhotoUrl;

        if (file != null) {
          profilePhotoUrl = await StorageMethods().uploadImageToStorage('profile_photo', file);
        } else {
          profilePhotoUrl = "https://static.thenounproject.com/png/354384-200.png";
        }

        UserLumus user = UserLumus(
          id: cred.user!.uid, 
          email: email, 
          username: username, 
          profilePhoto: profilePhotoUrl, 
          description: null, 
          following: [], 
          followers: [],
        );

        await _firestore.collection('Users').doc(cred.user!.uid).set(user.toJson());
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
          updateData['profile_photo'] = profilePhotoUrl;
        }
        await _firestore.collection('Users').doc(_auth.currentUser!.uid).update(updateData);

        response = "Sucesso!";
    } catch (error) {
      response = error.toString();
    }
    return response;
  }
}