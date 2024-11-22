import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';

// Input field flexible to use in all the app
class InputField extends StatelessWidget {
  final String? label; // Made label optional
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool labelAboveField; // Property to control label position
  final InputDecoration? decoration; // Allow custom decoration

  const InputField({
    super.key,
    this.label, // Label is now optional
    this.hintText,
    required this.controller,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.labelAboveField =
        false, // Default value is false (label on the same row)
    this.decoration, // Allow passing custom InputDecoration
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = decoration ??
        InputDecoration(
          labelText: label,
          labelStyle: AppTheme.paragraph.copyWith(fontSize: 18),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppTheme.grey2,
              width: 0.75,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.accent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
        );

    return labelAboveField
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (label != null && label!.isNotEmpty)
                Text(
                  label!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium, // Use theme text style
                ),
              if (label != null && label!.isNotEmpty)
                const SizedBox(height: 8.0),
              TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                textCapitalization: textCapitalization,
                style: const TextStyle(fontSize: 15.0),
                decoration: inputDecoration,
                validator: validator,
                onChanged: onChanged,
                obscureText: obscureText,
              ),
            ],
          )
        : Row(
            children: <Widget>[
              if (label != null && label!.isNotEmpty)
                SizedBox(
                  width: 100.0,
                  child: Text(
                    label!,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium, // Use theme text style
                  ),
                ),
              if (label != null && label!.isNotEmpty)
                const SizedBox(
                  width: 10.0,
                ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  textCapitalization: textCapitalization,
                  style: const TextStyle(fontSize: 15.0),
                  decoration: inputDecoration,
                  validator: validator,
                  onChanged: onChanged,
                  obscureText: obscureText,
                ),
              ),
            ],
          );
  }
}
