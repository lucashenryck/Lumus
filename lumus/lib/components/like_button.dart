import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.isLiked,
    required this.onTap
  });

  final bool isLiked;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Ionicons.heart : Ionicons.heart_outline,
        color: isLiked ? Colors.redAccent : Colors.grey,
      ),
    );
  }
}