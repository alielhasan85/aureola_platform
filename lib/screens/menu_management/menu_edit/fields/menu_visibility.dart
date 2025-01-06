// lib/screens/menu_management/menu_edit/fields/menu_visibility_option.dart

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuVisibilityOption extends StatelessWidget {
  final String titleKey;
  final String subtitleKey;
  final String iconPath;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const MenuVisibilityOption({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
    required this.iconPath,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        AppLocalizations.of(context)!.translate(titleKey),
        style: AppThemeLocal.paragraph,
      ),
      subtitle: Text(
        AppLocalizations.of(context)!.translate(subtitleKey),
        style: AppThemeLocal.paragraph.copyWith(
          fontSize: 12,
          color: AppThemeLocal.secondary,
        ),
      ),
      secondary: SvgPicture.asset(
        iconPath,
        width: 32,
        height: 32,
        colorFilter: const ColorFilter.mode(
          AppThemeLocal.primary,
          BlendMode.srcIn,
        ),
      ),
      value: value,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: BorderSide(
        color: AppThemeLocal.accent2,
        width: 1,
      ),
      activeColor: AppThemeLocal.grey2, // Set the accent color
      checkColor: AppThemeLocal.accent,
      onChanged: onChanged,
    );
  }
}
