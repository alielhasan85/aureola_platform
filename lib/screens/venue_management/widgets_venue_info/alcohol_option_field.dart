import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

// Enum for alcohol options
enum AlcoholOption { yes, no }

class AlcoholOptionField extends StatefulWidget {
  final double width;

  const AlcoholOptionField({super.key, required this.width});

  @override
  State<AlcoholOptionField> createState() => _AlcoholOptionFieldState();
}

class _AlcoholOptionFieldState extends State<AlcoholOptionField> {
  AlcoholOption? _alcoholOption = AlcoholOption.no;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("venue_sells_alcohol"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<AlcoholOption>(
                activeColor: AppTheme.accent,
                value: AlcoholOption.yes,
                groupValue: _alcoholOption,
                onChanged: (AlcoholOption? value) {
                  setState(() {
                    _alcoholOption = value;
                  });
                },
              ),
              Text(
                AppLocalizations.of(context)!.translate("yes"),
                style: AppTheme.paragraph,
              ),
              const SizedBox(width: 16),
              Radio<AlcoholOption>(
                activeColor: AppTheme.accent,
                value: AlcoholOption.no,
                groupValue: _alcoholOption,
                onChanged: (AlcoholOption? value) {
                  setState(() {
                    _alcoholOption = value;
                  });
                },
              ),
              Text(
                AppLocalizations.of(context)!.translate("no"),
                style: AppTheme.paragraph,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
