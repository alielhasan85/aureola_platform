import 'package:aureola_platform/localization/localization.dart';

import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/email_fields.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/location_picker_field copy.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/venue_type_dropdown.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/alcohol_option_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/default_language_dropdown.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/display_name_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/name_same_as_display_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/phone_number_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/venue_address_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/venue_name_field.dart';
import 'package:aureola_platform/screens/venue_management/widgets_venue_info/website_fields.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Breakpoints {
  static const double desktop = 1024;
  static const double tablet = 768;
  static const double mobile = 480;
}

class VenueInfo extends ConsumerStatefulWidget {
  const VenueInfo({Key? key}) : super(key: key);

  @override
  ConsumerState<VenueInfo> createState() => _VenueInfoState();
}

class _VenueInfoState extends ConsumerState<VenueInfo> {
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
        if (isTabletOrDesktop) HeaderContainer(userName: 'Ali Elhassan  g'),
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

                      // Calculate the width for each field
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
                          _buildFormFields(
                              columns, fieldWidth, spacing, containerWidth),
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

  Widget _buildFormFields(
      int columns, double fieldWidth, double spacing, double containerWidth) {
    if (columns == 1) {
      // Mobile layout: fields in a single column
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VenueNameField(width: fieldWidth),
          const SizedBox(height: 16),
          DisplayNameField(width: fieldWidth),
          const SizedBox(height: 16),
          NameSameAsDisplayField(width: fieldWidth),
          const SizedBox(height: 16),
          VenueTypeDropdown(width: fieldWidth),
          const SizedBox(height: 16),
          AlcoholOptionField(width: fieldWidth),
          const SizedBox(height: 16),
          DefaultLanguageDropdown(width: fieldWidth),
          const SizedBox(height: 16),
          WebsiteFields(width: fieldWidth),
          const SizedBox(height: 16),
          EmailFields(width: fieldWidth),
          const SizedBox(height: 16),
          PhoneNumberField(width: fieldWidth),
          const SizedBox(height: 16),
          VenueAddressField(width: fieldWidth),
          const SizedBox(height: 16),
          LocationPickerField(width: containerWidth)
        ],
      );
    } else {
      // Tablet/Desktop layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VenueNameField(width: fieldWidth),
              SizedBox(width: spacing),
              DisplayNameField(width: fieldWidth),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              NameSameAsDisplayField(width: fieldWidth),
              SizedBox(width: spacing),
              AlcoholOptionField(width: fieldWidth)
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: AppTheme.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 16),
          Row(
            children: [
              VenueTypeDropdown(width: fieldWidth),
              SizedBox(width: spacing),
              DefaultLanguageDropdown(width: fieldWidth)
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              WebsiteFields(width: fieldWidth),
              SizedBox(width: spacing),
              EmailFields(width: fieldWidth),
            ],
          ),
          const SizedBox(height: 16),
          PhoneNumberField(width: fieldWidth),
          const SizedBox(height: 8),
          Divider(color: AppTheme.accent.withOpacity(0.5), thickness: 0.5),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.translate("Address_"),
            style: AppTheme.tabItemText,
          ),
          const SizedBox(height: 16),
          VenueAddressField(width: containerWidth),

          const SizedBox(height: 16),
          LocationPickerField(width: containerWidth), // Add this line
        ],
      );
    }
  }
}
