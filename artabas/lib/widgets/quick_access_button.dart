import 'package:flutter/material.dart';

class QuickAccessButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const QuickAccessButton({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: Colors.black),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
