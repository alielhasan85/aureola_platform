// lib/screens/menu_management/menu_edit/fields/menu_description_fields.dart

import 'package:flutter/material.dart';

class MenuDescriptionFields extends StatelessWidget {
  final TextEditingController descriptionEnController;
  final TextEditingController descriptionArController;
  final String? Function(String?)? validatorEn;
  final String? Function(String?)? validatorAr;

  const MenuDescriptionFields({
    Key? key,
    required this.descriptionEnController,
    required this.descriptionArController,
    this.validatorEn,
    this.validatorAr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Description (English)
        TextFormField(
          controller: descriptionEnController,
          decoration: const InputDecoration(
            labelText: 'Description (English)',
          ),
          maxLines: 2,
          validator: validatorEn,
        ),
        const SizedBox(height: 8),
        // Description (Arabic)
        TextFormField(
          controller: descriptionArController,
          decoration: const InputDecoration(
            labelText: 'Description (Arabic)',
          ),
          maxLines: 2,
          validator: validatorAr,
        ),
      ],
    );
  }
}
