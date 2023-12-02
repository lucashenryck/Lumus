import 'package:cloud_firestore/cloud_firestore.dart';

class UserLumus{
  final String id;
  final String email;
  final String username;
  final String? profilePhoto;
  final String? description;
  final List following;
  final List followers;

  const UserLumus({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePhoto,
    required this.description,
    required this.following,
    required this.followers,
  });

  Map<String, dynamic> toJson() => {
      "user_id" : id,
      "email"   : email,
      "username"   : username,
      "profile_photo" : profilePhoto,
      "description" : description, 
      "following" : following,
      "followers" : followers
  };

  static UserLumus fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserLumus(
      username: snapshot['username'],
      email: snapshot['email'],
      id: snapshot['user_id'],
      profilePhoto: snapshot['profile_photo'],
      description: snapshot['description'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}