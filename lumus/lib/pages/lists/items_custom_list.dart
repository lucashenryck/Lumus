import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ItemsCustomList extends StatefulWidget {
  const ItemsCustomList({super.key, required this.customList});
  final Map<String, dynamic> customList;

  @override
  State<ItemsCustomList> createState() => _ItemsCustomListState();
}

class _ItemsCustomListState extends State<ItemsCustomList> {

  void _showRemoveItemDialog(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove item da lista?',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(3, 21, 37, 1),
            ),
          ),
          content: Text(
            'Você tem certeza que deseja remover esse item da lista?',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(3, 21, 37, 1),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancelar',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(3, 21, 37, 1),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Call the method to remove the item from the custom list
                _removeItemFromCustomList(itemId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Remover',
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

  void _removeItemFromCustomList(String itemId) {
  final userId = widget.customList['user_id'];
  final customListId = widget.customList['custom_list_id'];

  try {
    // Remove the item from the "Items" collection in Firestore
    FirebaseFirestore.instance
        .collection("Users collections")
        .doc(userId)
        .collection("Custom")
        .doc(customListId)
        .collection("Items")
        .doc(itemId)
        .delete();
  } catch (error) {
    print('Error removing item from custom list: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    final UserLumus user = Provider.of<UserProvider>(context).getUserLumus;
    bool isCurrentUserList = user.id == widget.customList['user_id'];
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        title: Text(
          widget.customList['name'],
          style: GoogleFonts.dmSans(
            color: Color.fromRGBO(229, 210, 131, 1),
            fontSize: 15,
          ),
        ),
        actions: [
          if(!isCurrentUserList)
          IconButton(
            onPressed: (){}, 
            icon: Icon(
              Ionicons.heart_outline
            )
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.customList['creator'],
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.customList['profile_photo'] ?? ''),
                  radius: 48,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(
                    widget.customList['description'],
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Color.fromRGBO(240, 240, 240, 1)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users collections")
                  .doc(widget.customList['user_id'])
                  .collection("Custom")
                  .doc(widget.customList['custom_list_id'])
                  .collection("Items")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ' + snapshot.error.toString()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum filme ou série na lista.',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(240, 240, 240, 1),
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // You can adjust the number of columns
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    mainAxisExtent: 120
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data!.docs[index];
                    String posterPath = item['poster_path'] ?? '';
                    return GridTile(
                      child: GestureDetector(
                        onLongPress: (){
                          _showRemoveItemDialog(context, item.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5, 
                            ),
                          ),
                          child: Image.network(
                            '${Constants.imagePath}$posterPath',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
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