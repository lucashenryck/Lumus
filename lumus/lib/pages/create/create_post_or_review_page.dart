import 'package:flutter/material.dart';
import 'package:lumus/pages/create/create_post.dart';
import 'package:lumus/pages/create/create_review.dart';

class CreatePostOrReviewPage extends StatefulWidget {
  const CreatePostOrReviewPage({super.key});

  @override
  State<CreatePostOrReviewPage> createState() => _CreatePostOrReviewPageState();
}

class _CreatePostOrReviewPageState extends State<CreatePostOrReviewPage> {
  List<bool> isSelected = [false, false]; // REVIEW, POST

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
      appBar: AppBar(
        title: const Text('O que você deseja criar?'),
        leading: const BackButton(),
        backgroundColor: Color.fromRGBO(19, 32, 67, 1),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ToggleButtons(
                borderColor: Color.fromRGBO(240, 240, 240, 1),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'POST',
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,
                        color: isSelected[0] ? Color.fromRGBO(19, 32, 67, 1) : Color.fromRGBO(240, 240, 240, 1)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'REVIEW',
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,
                        color: isSelected[1] ? Color.fromRGBO(19, 32, 67, 1) : Color.fromRGBO(240, 240, 240, 1)
                      ),
                    ),
                  ),
                ],
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                constraints: BoxConstraints(
                minWidth: 150,
                minHeight: 60,
                ),
                selectedColor: Color.fromRGBO(240, 240, 240, 1),
                borderRadius: BorderRadius.circular(10),
                fillColor: Color.fromRGBO(240, 240, 240, 1),
              ),
              SizedBox(height: 50),
              Visibility(
                visible: isSelected[0], // Show only when "POSTAGEM" is selected
                child: MyPost(),
              ),
              Visibility(
                visible: isSelected[1], // Show only when "POSTAGEM" is selected
                child: MyReview(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}