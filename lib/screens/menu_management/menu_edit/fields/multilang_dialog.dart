// lib/screens/common/multilang_field_dialog.dart

import 'package:flutter/material.dart';

/// A generic dialog to edit a Map<String, String> for multiple languages.
/// [initialValues]: The existing map, e.g. {'en': 'Breakfast', 'ar': 'الإفطار'}.
/// [availableLanguages]: The list of language codes or labels, e.g. ['en','ar'].
/// [title]: The dialog title, e.g. "Edit Menu Name".
/// [onSave]: Callback with the final updated map.
class MultilangFieldDialog extends StatefulWidget {
  final Map<String, String> initialValues;
  final List<String> availableLanguages;
  final String title;
  final ValueChanged<Map<String, String>> onSave;

  const MultilangFieldDialog({
    super.key,
    required this.initialValues,
    required this.availableLanguages,
    required this.title,
    required this.onSave,
  });

  @override
  _MultilangFieldDialogState createState() => _MultilangFieldDialogState();
}

class _MultilangFieldDialogState extends State<MultilangFieldDialog> {
  late Map<String, String> _localValues;

  @override
  void initState() {
    super.initState();
    _localValues = Map<String, String>.from(widget.initialValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.availableLanguages.map((lang) {
            final currentValue = _localValues[lang] ?? '';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Language: $lang'),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: currentValue,
                    onChanged: (val) {
                      setState(() {
                        _localValues[lang] = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter text for "$lang"',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_localValues);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
