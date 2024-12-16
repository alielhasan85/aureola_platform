import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class TaglineWidget extends StatelessWidget {
  final double width;
  final TextEditingController controller;

  TaglineWidget({
    super.key,
    required this.width,
    TextEditingController? controller,
  }) : controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("Tagline"),
            style: AppTheme.paragraph,
          ),
          const SizedBox(height: 6),
          TextField(
            style: AppTheme.paragraph,
            cursorColor: AppTheme.accent,
            controller: controller,
            decoration: AppTheme.textFieldinputDecoration(
              hint: AppLocalizations.of(context)!
                  .translate("enter_venue_tagline"),
            ),
          ),
        ],
      ),
    );
  }
}
