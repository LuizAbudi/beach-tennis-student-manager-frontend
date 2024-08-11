// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PulseIcon extends StatefulWidget {
  final IconData icon;

  const PulseIcon({super.key, required this.icon});

  @override
  _PulseIconState createState() => _PulseIconState();
}

class _PulseIconState extends State<PulseIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Certifique-se de descartar o controlador para liberar os recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: Icon(
        widget.icon,
        color: const Color.fromRGBO(255, 98, 62, 1),
        size: 200,
      ),
    );
  }
}
