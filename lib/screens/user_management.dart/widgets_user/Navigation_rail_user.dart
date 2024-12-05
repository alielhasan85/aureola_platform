import 'package:aureola_platform/models/common/logo_icon.dart';
import 'package:aureola_platform/providers/main_navigation_provider.dart';
import 'package:aureola_platform/providers/main_title_provider.dart';
import 'package:aureola_platform/providers/user_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_item.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

import 'package:aureola_platform/providers/user_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aureola_platform/screens/main_page/widgets/nav_item.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class NavigationRailUser extends ConsumerStatefulWidget {
  final bool isDrawer;

  const NavigationRailUser({
    super.key,
    this.isDrawer = false,
  });

  @override
  ConsumerState<NavigationRailUser> createState() => _NavigationRailUserState();
}

class _NavigationRailUserState extends ConsumerState<NavigationRailUser> {
  void _updateIndex(int index) {
    ref.read(userProfileSelectedMenuIndexProvider.notifier).state = index;

    // Close the drawer if it's open
    if (widget.isDrawer) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final selectedIndex = ref.watch(userProfileSelectedMenuIndexProvider);

    // Decide the alignment and width based on whether it's a drawer or not
    final crossAxisAlignment =
        widget.isDrawer ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final containerWidth = widget.isDrawer ? double.infinity : 230.0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: widget.isDrawer
            ? null
            : Border(
                left: isRtl
                    ? const BorderSide(
                        width: 0.5, color: Color.fromARGB(255, 218, 207, 207))
                    : BorderSide.none,
                right: !isRtl
                    ? const BorderSide(width: 0.5, color: AppTheme.divider)
                    : BorderSide.none,
              ),
      ),
      width: containerWidth,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16,
            left: 12,
            top: 16,
            bottom: 12,
          ),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              // Header (Logo, Title)
              if (!widget.isDrawer) ...[const AppLogo()],

              const SizedBox(
                height: 24,
              ),

              // Navigation Items
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: NavigationItem(
                  label: AppLocalizations.of(context)!.translate('profile_'),
                  leadingIconPath: 'assets/icons/profile.svg',
                  isSelected: selectedIndex == 0,
                  onTap: () => _updateIndex(0),
                ),
              ),
              const SizedBox(height: 10),
              NavigationItem(
                label: AppLocalizations.of(context)!.translate('billing_'),
                leadingIconPath: 'assets/icons/billing.svg',
                isSelected: selectedIndex == 1,
                onTap: () => _updateIndex(1),
              ),
              const SizedBox(height: 10),
              NavigationItem(
                label: AppLocalizations.of(context)!.translate('plan'),
                leadingIconPath: 'assets/icons/plan.svg',
                isSelected: selectedIndex == 2,
                onTap: () => _updateIndex(2),
              ),
              const SizedBox(height: 10),
              NavigationItem(
                label: AppLocalizations.of(context)!
                    .translate('notifications_setting'),
                leadingIconPath: 'assets/icons/notification.svg',
                isSelected: selectedIndex == 3,
                onTap: () => _updateIndex(3),
              ),
              const SizedBox(height: 10),
              NavigationItem(
                label: AppLocalizations.of(context)!.translate('cards'),
                leadingIconPath: 'assets/icons/cards.svg',
                isSelected: selectedIndex == 4,
                onTap: () => _updateIndex(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
