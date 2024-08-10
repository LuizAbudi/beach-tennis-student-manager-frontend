import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double? width;
  final double? height;
  final IconData? icon;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.width,
    this.height,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200, // Default width
      height: height ?? 50, // Default height
      decoration: BoxDecoration(
        gradient: color == null
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 159, 137),
                  Color.fromARGB(255, 255, 98, 62)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: color, // If a color is provided, use it
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 2, // Spread of the shadow
            blurRadius: 8, // Blur effect of the shadow
            offset: const Offset(0, 2), // Position of the shadow (X, Y)
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Makes the button background transparent
          shadowColor: Colors.transparent, // Removes shadow
        ),
        onPressed: onPressed, // Call the onPressed callback
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8), // Adds space between icon and text
            ],
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
