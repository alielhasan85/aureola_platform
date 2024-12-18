// alcohol_option_field.dart

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

enum AlcoholOption { yes, no }

class AlcoholOptionField extends StatefulWidget {
  final double width;
  final ValueChanged<bool>? onChanged;
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
  void didUpdateWidget(covariant AlcoholOptionField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the initialValue changes in the parent (e.g., after cancel/reset),
    // update the local state accordingly.
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _alcoholOption =
            widget.initialValue ? AlcoholOption.yes : AlcoholOption.no;
      });
    }
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
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<AlcoholOption>(
                activeColor: AppThemeLocal.accent,
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
                style: AppThemeLocal.paragraph,
              ),
              const SizedBox(width: 16),
              Radio<AlcoholOption>(
                activeColor: AppThemeLocal.accent,
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
                style: AppThemeLocal.paragraph,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
