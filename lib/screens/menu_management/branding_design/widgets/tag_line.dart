import 'package:aureola_platform/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class TaglineWidget extends ConsumerStatefulWidget {
  const TaglineWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<TaglineWidget> createState() => _TaglineWidgetState();
}

class _TaglineWidgetState extends ConsumerState<TaglineWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentValue = ref.read(taglineProvider);
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
          AppLocalizations.of(context)!.translate("Tagline"),
          style: AppTheme.paragraph,
        ),
        const SizedBox(height: 6),
        TextField(
          maxLines: 1,
          style: AppTheme.paragraph,
          cursorColor: AppTheme.accent,
          controller: _controller,
          decoration: AppTheme.textFieldinputDecoration(
            hint:
                AppLocalizations.of(context)!.translate("enter_venue_tagline"),
          ),
          onChanged: (val) {
            // Update provider whenever text changes
            ref.read(taglineProvider.notifier).state = val;
          },
        ),
      ],
    );
  }
}
