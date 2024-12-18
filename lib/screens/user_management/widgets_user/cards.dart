import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';

class CardsTab extends StatelessWidget {
  const CardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Card Management',
        style: AppThemeLocal.paragraph,
      ),
    );
  }
}
