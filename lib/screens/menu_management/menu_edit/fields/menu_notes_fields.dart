// lib/screens/menu_management/menu_edit/fields/menu_notes_fields.dart

import 'package:flutter/material.dart';

class MenuNotesFields extends StatelessWidget {
  final TextEditingController notesEnController;
  final TextEditingController notesArController;

  const MenuNotesFields({
    Key? key,
    required this.notesEnController,
    required this.notesArController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Notes (English)
        TextFormField(
          controller: notesEnController,
          decoration: const InputDecoration(
            labelText: 'Notes (English)',
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        // Notes (Arabic)
        TextFormField(
          controller: notesArController,
          decoration: const InputDecoration(
            labelText: 'Notes (Arabic)',
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
