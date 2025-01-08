// tagline_widget.dart

import 'package:aureola_platform/widgest/multilang_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class TaglineWidget extends ConsumerStatefulWidget {
  final double width;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const TaglineWidget({
    super.key,
    required this.width,
    required this.controller,
    this.validator,
  });

  @override
  ConsumerState<TaglineWidget> createState() => _TaglineWidgetState();
}

class _TaglineWidgetState extends ConsumerState<TaglineWidget> {
  Future<void> _showMultiLangDialog(BuildContext context, String currentLang) async {
    final venue = ref.read(draftVenueProvider);
    final localization = AppLocalizations.of(context)!;
    if (venue == null) return;

    final currentMap = venue.tagLine;
    final availableLangs = venue.languageOptions.isNotEmpty
        ? venue.languageOptions
        : [currentLang];

    final updatedMap = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => MultiLangDialog(
        label: localization.translate("Tagline"),
        initialValues: currentMap,
        availableLanguages: availableLangs,
        defaultLang: venue.additionalInfo['defaultLanguage'] ?? 'en',
        googleApiKey: AppThemeLocal.googleApiKey,
      ),
    );

    if (updatedMap != null) {
      ref.read(draftVenueProvider.notifier).updateTagLineMap(updatedMap);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.controller.text = updatedMap[currentLang] ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final currentLang = ref.watch(languageProvider);
    final venue = ref.watch(draftVenueProvider);
    final entireMap = venue?.tagLine ?? {currentLang: ''};

    final newText = entireMap[currentLang] ?? '';
    if (widget.controller.text != newText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.controller.text = newText;
        }
      });
    }

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.translate("Tagline"),
            style: AppThemeLocal.paragraph,
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            style: AppThemeLocal.paragraph,
            cursorColor: AppThemeLocal.accent,
            decoration: AppThemeLocal.textFieldinputDecoration(
              hint: localization.translate("enter_venue_tagline"),
              suffixIcon: (venue?.languageOptions.length ?? 0) > 1
                  ? IconButton(
                      icon: const Icon(Icons.translate,
                          color: AppThemeLocal.accent),
                      onPressed: () => _showMultiLangDialog(context, currentLang),
                    )
                  : null,
            ),
            onChanged: (val) {
              final updated = {...entireMap};
              updated[currentLang] = val;
              ref.read(draftVenueProvider.notifier).updateTagLineMap(updated);
            },
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
