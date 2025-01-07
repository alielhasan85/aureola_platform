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
    Key? key,
    required this.width,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  ConsumerState<TaglineWidget> createState() => _TaglineWidgetState();
}

class _TaglineWidgetState extends ConsumerState<TaglineWidget> {
  late String currentLang;

  @override
  void initState() {
    super.initState();
    currentLang = ref.read(languageProvider);
  }

  Future<void> _showMultiLangDialog(BuildContext context) async {
    final venue = ref.read(draftVenueProvider);
    if (venue == null) return;

    final currentMap = venue.tagLine;
    final availableLangs = venue.languageOptions.isNotEmpty
        ? venue.languageOptions
        : [currentLang];

    final updatedMap = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => MultiLangDialog(
        label: 'Edit Tagline',
        initialValues: currentMap,
        availableLanguages: availableLangs,
        defaultLang: venue.additionalInfo['defaultLanguage'] ?? 'en',
        googleApiKey: 'AIzaSyDGko8GkwRTwIukbxljTuuvocEdUgWxXRA',
      ),
    );
    if (updatedMap != null) {
      ref.read(draftVenueProvider.notifier).updateTagLineMap(updatedMap);

      final updatedText = updatedMap[currentLang] ?? '';
      widget.controller.text = updatedText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final venue = ref.watch(draftVenueProvider);
    final entireMap = venue?.tagLine ?? {currentLang: ''};

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
                      onPressed: () => _showMultiLangDialog(context),
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
