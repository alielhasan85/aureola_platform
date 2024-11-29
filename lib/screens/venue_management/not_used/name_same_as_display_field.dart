import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class NameSameAsDisplayField extends StatefulWidget {
  final double width;

  const NameSameAsDisplayField({Key? key, required this.width})
      : super(key: key);

  @override
  _NameSameAsDisplayFieldState createState() => _NameSameAsDisplayFieldState();
}

class _NameSameAsDisplayFieldState extends State<NameSameAsDisplayField> {
  bool _isSame = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Row(
        children: [
          Checkbox(
            value: _isSame,
            activeColor: AppTheme.accent,
            onChanged: (value) {
              setState(() {
                _isSame = value!;
              });
            },
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!
                  .translate("display_name_same_as_venue_name"),
              style: AppTheme.paragraph,
            ),
          ),
        ],
      ),
    );
  }
}
