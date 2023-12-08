import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumus/pages/lists/items_custom_list.dart';
import 'package:lumus/resources/firestore_methods.dart';

class CustomListUi extends StatefulWidget {
  const CustomListUi({super.key, required this.customList});
   final DocumentSnapshot customList;

  @override
  State<CustomListUi> createState() => _CustomListUiState();
}

class _CustomListUiState extends State<CustomListUi> {
  late Map<String, dynamic> customList;

  @override
  void initState() {
    super.initState();
    customList = widget.customList.data() as Map<String, dynamic>;
  }

  void _navigateToItemsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemsCustomList(
          customList: customList,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Excluir lista?',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(3, 21, 37, 1),
            ),
          ),
          content: Text(
            'Você tem certeza que desejar excluir essa lista?',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(3, 21, 37, 1),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(3, 21, 37, 1),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteCustomList();
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text(
                'Excluir',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteCustomList() {
    FirestoreMethods().deleteCustomList(FirebaseAuth.instance.currentUser!.uid, customList['custom_list_id']);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToItemsPage,
      onLongPress: _showDeleteConfirmationDialog,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(customList['profile_photo'] ?? ''),
              radius: 24,
            ),
            title: Text(
              customList['name'],
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(229, 210, 131, 1),
              ),
            ),
            subtitle: Text(
              customList['description'],
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color.fromRGBO(240, 240, 240, 1),
              ),
            ),
          ),
          Divider(color: Color.fromRGBO(240, 240, 240, 1))
        ],
      ),
    );
  }
}