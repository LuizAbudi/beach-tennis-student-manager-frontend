import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? fontWeight;
  final String type; // Add type parameter

  const CustomText({
    super.key,
    required this.text,
    this.size,
    this.color,
    this.fontWeight,
    this.type = 'header', // Default type is paragraph
  });

  @override
  Widget build(BuildContext context) {
    double finalSize;
    FontWeight finalFontWeight;

    if (type == 'header') {
      finalSize = 28;
      finalFontWeight = FontWeight.bold;
    } else if (type == 'paragraph') {
      finalSize = 16;
      finalFontWeight = FontWeight.w500;
    } else {
      finalSize = size ?? 16;
      finalFontWeight = fontWeight ?? FontWeight.normal;
    }

    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: color ?? const Color.fromARGB(255, 22, 24, 35),
          fontSize: finalSize,
          fontWeight: finalFontWeight,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
