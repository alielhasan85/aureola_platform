import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';

class NotificationsSettingTab extends StatelessWidget {
  const NotificationsSettingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Notifications Settings',
        style: AppThemeLocal.paragraph,
      ),
    );
  }
}
