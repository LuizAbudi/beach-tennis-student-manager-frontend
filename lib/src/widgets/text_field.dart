import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool isPassword;
  final bool isTextArea;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.hint,
    this.isPassword = false,
    this.isTextArea = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    if (widget.isTextArea) {
      return TextField(
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        maxLines: null,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(
            widget.icon,
            color: Colors.white,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        obscureText: widget.isPassword,
      );
    } else {
      return TextField(
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(
            widget.icon,
            color: Colors.white60,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white60,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        obscureText: widget.isPassword ? _obscureText : false,
      );
    }
  }
}
