// lib/screens/menu_management/menu_edit/fields/menu_image_fields.dart

import 'package:flutter/material.dart';

class MenuImageFields extends StatelessWidget {
  final TextEditingController imageUrlController;
  final TextEditingController additionalImage1Controller;
  final TextEditingController additionalImage2Controller;

  const MenuImageFields({
    super.key,
    required this.imageUrlController,
    required this.additionalImage1Controller,
    required this.additionalImage2Controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Image URL
        TextFormField(
          controller: imageUrlController,
          decoration: const InputDecoration(
            labelText: 'Image URL',
          ),
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 8),
        // Additional Image 1
        TextFormField(
          controller: additionalImage1Controller,
          decoration: const InputDecoration(
            labelText: 'Additional Image URL 1',
          ),
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 8),
        // Additional Image 2
        TextFormField(
          controller: additionalImage2Controller,
          decoration: const InputDecoration(
            labelText: 'Additional Image URL 2',
          ),
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }
}
