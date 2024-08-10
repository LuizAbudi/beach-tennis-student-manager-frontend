// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? placeholder;
  final IconData? prefixIcon;
  final bool isPassword;

  const CustomInput({
    super.key,
    this.controller,
    this.label,
    this.placeholder,
    this.prefixIcon,
    this.isPassword = false,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                widget.label!,
                style: const TextStyle(
                  color: Color.fromARGB(255, 22, 24, 35),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          TextField(
            controller: widget.controller,
            obscureText: widget.isPassword && !_isPasswordVisible,
            style: const TextStyle(
              color: Color.fromRGBO(110, 111, 118, 0.7),
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: const TextStyle(
                color: Color.fromRGBO(110, 111, 118, 0.7),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon:
                  widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
