import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? textSize;
  final Color? textColor;
  final Color? color;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool? withShadow;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.width,
    this.height,
    this.icon,
    this.iconColor,
    this.onPressed,
    this.isLoading = false,
    this.textSize,
    this.textColor,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 50.0,
      child: DecoratedBox(
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
          color: color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: withShadow == true
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: iconColor ?? Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontSize: textSize ?? 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
