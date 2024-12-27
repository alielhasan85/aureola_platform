import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/service/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectionList extends ConsumerWidget {
  final String layout; // 'isDesktop', 'isTablet', 'isMobile', or fallback

  const SectionList({
    super.key,
    required this.layout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftVenue = ref.watch(draftVenueProvider);

    // Handle null draftVenue gracefully
    if (draftVenue == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: (layout != 'isMobile')
          ? const EdgeInsets.all(16)
          : const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'section list',
            style: AppThemeLocal.paragraph,
          ),
        ],
      ),
    );
  }
}
