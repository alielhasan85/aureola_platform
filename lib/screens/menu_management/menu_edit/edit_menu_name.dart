import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class MenuNameFields extends StatelessWidget {
  final TextEditingController enController;
  final TextEditingController arController;
  final String? Function(String?) enValidator;
  final String? Function(String?) arValidator;

  const MenuNameFields({
    super.key,
    required this.enController,
    required this.arController,
    required this.enValidator,
    required this.arValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Menu Name - English
        TextFormField(
          controller: enController,
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context)!.translate('Menu Name (English)'),
          ),
          validator: enValidator,
        ),
        SizedBox(height: 8),
        // Menu Name - Arabic
        TextFormField(
          controller: arController,
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context)!.translate('Menu Name (Arabic)'),
          ),
          validator: arValidator,
        ),
      ],
    );
  }
}
