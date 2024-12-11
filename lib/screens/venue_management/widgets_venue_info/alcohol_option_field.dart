import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

enum AlcoholOption { yes, no }

class AlcoholOptionField extends StatefulWidget {
  final double width;
  final ValueChanged<bool>? onChanged;

  // Add an optional parameter to accept the initial alcohol setting.
  final bool initialValue;

  const AlcoholOptionField({
    super.key,
    required this.width,
    this.onChanged,
    this.initialValue = false, // default to false if not provided
  });

  @override
  State<AlcoholOptionField> createState() => _AlcoholOptionFieldState();
}

class _AlcoholOptionFieldState extends State<AlcoholOptionField> {
  AlcoholOption? _alcoholOption;

  @override
  void initState() {
    super.initState();
    // Initialize based on the passed initialValue
    _alcoholOption = widget.initialValue ? AlcoholOption.yes : AlcoholOption.no;
  }

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
                  if (widget.onChanged != null && value != null) {
                    widget.onChanged!(value == AlcoholOption.yes);
                  }
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
                  if (widget.onChanged != null && value != null) {
                    widget.onChanged!(value == AlcoholOption.yes);
                  }
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
