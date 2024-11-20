import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:aureola_platform/theme/theme.dart';

class HeaderContainer extends StatelessWidget {
  final String userName;

  HeaderContainer({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final currentDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    return Container(
      width: double.infinity,
      height: 40,
      color: AppTheme.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 18, left: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
//Google API key
// AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA

            Text(
              'Welcome $userName',
              style: AppTheme.tabItemText
                  .copyWith(color: AppTheme.secondary, fontSize: 14),
            ),
            Text(
              currentDateTime,
              style: AppTheme.tabItemText
                  .copyWith(color: AppTheme.secondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
