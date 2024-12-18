import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class JobTitleField extends StatelessWidget {
  final double width;
  final TextEditingController controller;

  const JobTitleField({
    Key? key,
    required this.width,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('Job_Title'),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            controller: controller,
            decoration: AppThemeLocal.textFieldinputDecoration(
              hint: AppLocalizations.of(context)!.translate('Job_Title'),
            ),
          ),
        ],
      ),
    );
  }
}
