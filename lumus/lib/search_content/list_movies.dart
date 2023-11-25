import 'package:flutter/material.dart';

class ListMoviesSlider extends StatelessWidget {
  const ListMoviesSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, 
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Color.fromRGBO(240, 240, 240, 1),
                height: 225,
                width: 140,
              ),
            ),
          );
        },
      ),
    );
  }
}
