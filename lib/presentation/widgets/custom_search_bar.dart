import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Rechercher...',
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
        ),
      ),
    );
  }
}
