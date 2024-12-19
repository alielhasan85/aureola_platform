import 'package:aureola_platform/providers/providers.dart'; // Make sure this file contains displayNameProvider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class DisplayName extends ConsumerStatefulWidget {
  const DisplayName({super.key});

  @override
  ConsumerState<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends ConsumerState<DisplayName> {
  late TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    final venue = ref.read(venueProvider);

    _controller = TextEditingController(text: venue!.venueName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("Display_Name"),
          style: AppThemeLocal.paragraph,
        ),
        const SizedBox(height: 6),
        TextField(
          style: AppThemeLocal.paragraph,
          cursorColor: AppThemeLocal.accent,
          controller: _controller,
          decoration: AppThemeLocal.textFieldinputDecoration(
            hint: AppLocalizations.of(context)!
                .translate("enter_venue_display_name"),
          ),
          onChanged: (val) {
            ref.read(displayNameProvider.notifier).state = val;
          },
        ),
      ],
    );
  }
}
