import 'package:aureola_platform/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class DisplayName extends ConsumerStatefulWidget {
  const DisplayName({Key? key}) : super(key: key);

  @override
  ConsumerState<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends ConsumerState<DisplayName> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentValue = ref.read(displayNameProvider);
    _controller = TextEditingController(text: currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("Display_Name"),
          style: AppTheme.paragraph,
        ),
        const SizedBox(height: 6),
        TextField(
          style: AppTheme.paragraph,
          cursorColor: AppTheme.accent,
          controller: _controller,
          decoration: AppTheme.textFieldinputDecoration(
            hint: AppLocalizations.of(context)!
                .translate("enter_venue_display_name"),
          ),
          onChanged: (val) {
            // Update provider whenever text changes
            ref.read(displayNameProvider.notifier).state = val;
          },
        ),
      ],
    );
  }
}
