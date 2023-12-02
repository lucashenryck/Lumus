import 'package:cloud_firestore/cloud_firestore.dart';

class CustomList{
  final String userId;
  final String name;
  final items;

  CustomList({
    required this.userId,
    required this.name,
    required this.items
  });

  Map<String, dynamic> toJson() => {
      "user_id"   : userId,
      "name"   : name,
      "items" : items
  };

  static CustomList fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return CustomList(
      userId: snapshot['user_id'],
      name: snapshot['name'],
      items: snapshot['items']
    );
  }
}