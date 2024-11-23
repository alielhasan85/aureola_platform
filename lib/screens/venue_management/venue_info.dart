import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/screens/main_page/widgets/venue_type_dropdown.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Breakpoints {
  static const double desktop = 1024;
  static const double tablet = 768;
  static const double mobile = 480;
}

// Define the AlcoholOption enum
enum AlcoholOption { yes, no }

class VenueInfo extends ConsumerStatefulWidget {
  const VenueInfo({super.key});

  @override
  ConsumerState<VenueInfo> createState() => _VenueInfoState();
}

class _VenueInfoState extends ConsumerState<VenueInfo> {
  final TextEditingController _venueNameController =
      TextEditingController(text: 'Al bait el Shami');

  AlcoholOption? _alcoholOption = AlcoholOption.no; // Default to 'No'

  @override
  void dispose() {
    _venueNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine container width based on breakpoints
    double containerWidth;
    if (screenWidth >= Breakpoints.desktop) {
      containerWidth = screenWidth * 0.45;
    } else if (screenWidth >= Breakpoints.tablet) {
      containerWidth = screenWidth * 0.7;
    } else {
      containerWidth = screenWidth * 0.9;
    }

    final isTabletOrDesktop = screenWidth >= Breakpoints.tablet;

    return Column(
      children: [
        if (isTabletOrDesktop) HeaderContainer(userName: 'Ali Elhassan'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: containerWidth,
              margin: EdgeInsets.symmetric(
                vertical: isTabletOrDesktop ? 30 : 12,
              ),
              decoration: AppTheme.cardDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final containerWidth = constraints.maxWidth;

                      // Decide the number of columns
                      int columns = isTabletOrDesktop ? 2 : 1;

                      // Calculate the width for each TextField
                      double spacing = 16;
                      double fieldWidth = columns == 1
                          ? containerWidth
                          : (containerWidth - spacing) / 2;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildHeader(isTabletOrDesktop),
                          const SizedBox(height: 16),
                          _buildFormFields(columns, fieldWidth, spacing),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isTabletOrDesktop) const AppFooter(),
      ],
    );
  }

  Widget _buildHeader(bool isLargeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("venue_info_title"),
          style: AppTheme.heading1,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isLargeScreen ? 100 : 50),
            ),
            elevation: 5,
            padding: isLargeScreen
                ? const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
                : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          onPressed: () {
            // TODO: Add new venue functionality
          },
          child: Text(
            AppLocalizations.of(context)!.translate("Add_new_venue"),
            style: AppTheme.buttonText.copyWith(
              fontSize: isLargeScreen ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(int columns, double fieldWidth, double spacing) {
    if (columns == 1) {
      // Mobile layout: fields in a single column
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: fieldWidth,
            child: TextField(
              cursorColor: AppTheme.accent,
              controller: _venueNameController,
              decoration: AppTheme.inputDecoration(
                label: AppLocalizations.of(context)!.translate("venue_name"),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: fieldWidth,
            child: TextField(
              cursorColor: AppTheme.accent,
              decoration: AppTheme.inputDecoration(
                label: AppLocalizations.of(context)!.translate("display_name"),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: fieldWidth,
            child: _buildAlcoholOptionSection(context),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: fieldWidth,
            child: TextField(
              cursorColor: AppTheme.accent,
              decoration: AppTheme.inputDecoration(
                label: AppLocalizations.of(context)!.translate("web_site"),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // New section for "Venue sells alcohol"
          SizedBox(
            width: fieldWidth,
            child: _buildAlcoholOptionSection(context),
          ),
        ],
      );
    } else {
      // Tablet/Desktop layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: fieldWidth,
                child: TextField(
                  cursorColor: AppTheme.accent,
                  controller: _venueNameController,
                  decoration: AppTheme.inputDecoration(
                    label:
                        AppLocalizations.of(context)!.translate("venue_name"),
                  ),
                ),
              ),
              SizedBox(width: spacing),
              SizedBox(
                width: fieldWidth,
                child: TextField(
                  cursorColor: AppTheme.accent,
                  decoration: AppTheme.inputDecoration(
                    label:
                        AppLocalizations.of(context)!.translate("display_name"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // New section for "Venue sells alcohol"
          SizedBox(
            width: fieldWidth,
            child: _buildAlcoholOptionSection(context),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              SizedBox(
                width: fieldWidth,
                child: TextField(
                  cursorColor: AppTheme.accent,
                  decoration: AppTheme.inputDecoration(
                    label: AppLocalizations.of(context)!.translate("web_site"),
                  ).copyWith(
                    hintText: AppLocalizations.of(context)!
                        .translate("enter_web_site"),
                  ),
                ),
              ),
              SizedBox(width: spacing),
              SizedBox(
                  width: fieldWidth,
                  child: TextField(
                    cursorColor: AppTheme.accent,
                    decoration: AppTheme.inputDecoration(
                      label: AppLocalizations.of(context)!.translate("email"),
                    ).copyWith(
                      hintText: AppLocalizations.of(context)!
                          .translate("enter_email"),
                    ),
                  )),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              SizedBox(
                width: fieldWidth,
                child: TextField(
                  cursorColor: AppTheme.accent,
                  decoration: AppTheme.inputDecoration(
                    label: AppLocalizations.of(context)!.translate("web_site"),
                  ).copyWith(
                    hintText: AppLocalizations.of(context)!
                        .translate("enter_web_site"),
                  ),
                ),
              ),
              SizedBox(width: spacing),
              SizedBox(
                width: fieldWidth,
                child: VenueTypeDropdown(),
              ),
            ],
          ),
        ],
      );
    }
  }

  // Enum for alcohol options

  Widget _buildAlcoholOptionSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate("venue_sells_alcohol"),
          style: AppTheme.paragraph,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Radio<AlcoholOption>(
              activeColor: AppTheme.accent,
              value: AlcoholOption.yes,
              groupValue: _alcoholOption,
              onChanged: (AlcoholOption? value) {
                setState(() {
                  _alcoholOption = value;
                });
              },
            ),
            Text(
              AppLocalizations.of(context)!.translate("yes"),
              style: AppTheme.paragraph,
            ),
            const SizedBox(width: 16),
            Radio<AlcoholOption>(
              activeColor: AppTheme.accent,
              value: AlcoholOption.no,
              groupValue: _alcoholOption,
              onChanged: (AlcoholOption? value) {
                setState(() {
                  _alcoholOption = value;
                });
              },
            ),
            Text(
              AppLocalizations.of(context)!.translate("no"),
              style: AppTheme.paragraph,
            ),
          ],
        ),
      ],
    );
  }
}
