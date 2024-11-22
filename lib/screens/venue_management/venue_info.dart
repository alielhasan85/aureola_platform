import 'package:aureola_platform/localization/localization.dart';
import 'package:aureola_platform/screens/main_page/widgets/custom_footer.dart';
import 'package:aureola_platform/screens/main_page/widgets/header_venue.dart';
import 'package:aureola_platform/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VenueInfo extends ConsumerStatefulWidget {
  const VenueInfo({super.key});

  @override
  ConsumerState<VenueInfo> createState() => _VenueInfoState();
}

class _VenueInfoState extends ConsumerState<VenueInfo> {
  final TextEditingController _venueNameController =
      TextEditingController(text: 'Al bait el Shami');

  @override
  void dispose() {
    _venueNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define the width dynamically based on screen size
    double containerWidth = screenWidth > 1200
        ? screenWidth * 0.45
        : screenWidth > 800
            ? screenWidth * 0.6
            : screenWidth * 0.9;

    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderContainer(userName: 'Ali Elhassan'),
              Expanded(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    decoration:
                        AppTheme.cardDecoration, // Use extracted decoration
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .translate("venue_info_title"),
                                style: AppTheme.heading1,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5E1E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () {
                                  // TODO: to add creating new page
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("Add_new_venue"),
                                    style: AppTheme.buttonText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _venueNameController,
                                  decoration: AppTheme.inputDecoration(
                                    label: AppLocalizations.of(context)!
                                        .translate("venue_name"),
                                  ),
                                  style: AppTheme.paragraph,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'venue name',
                                    labelStyle: AppTheme.paragraph
                                        .copyWith(fontSize: 18),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppTheme.grey2,
                                        width: 0.75,
                                      ),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppTheme.accent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const AppFooter(),
      ],
    );
  }
}
