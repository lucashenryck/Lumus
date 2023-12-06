import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
        isLiked ? Iconsax.heart5 : Iconsax.heart,
        color: isLiked ? Colors.redAccent : Color.fromRGBO(240, 240, 240, 1),
      ),
    );
  }
}