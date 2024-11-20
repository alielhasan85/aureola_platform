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
  // late TextEditingController _venueNameController;
  final TextEditingController _venueNameController =
      TextEditingController(text: 'Al bait el Shami');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              HeaderContainer(userName: 'Ali Elhassan'),

              // Dynamic Content Container
              Expanded(
                child: Container(
                  width: 690,
                  margin: const EdgeInsets.only(
                      left: 60, top: 40, bottom: 26, right: 40),
                  //padding: const EdgeInsets.all(60),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x4C000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translate("venue_info_title"),
                              style: AppTheme.heading1,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFFFF5E1E), // Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      100), // Rounded corners
                                ),
                                // shadowColor:
                                //     const Color(0x26000000), // Shadow color
                                elevation: 5, // Elevation to apply shadow
                              ),
                              onPressed: () {
                                // TODO: to add creating new page
                              },
                              child: // Add space between icon and text
                                  Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("Add_new_venue"),
                                  style: AppTheme.buttonText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(children: [
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _venueNameController,
                            style: AppTheme.paragraph,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!
                                  .translate("venue_name"),
                              labelStyle:
                                  AppTheme.paragraph.copyWith(fontSize: 18),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppTheme
                                      .grey2, // Grey border when not focused
                                  width: 0.75,
                                ),
                                borderRadius: BorderRadius.circular(
                                    6.0), // Optional: Add radius if needed
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme
                                      .accent, // Accent color when focused
                                  width: 1.0, // Thicker border when focused
                                ),
                                borderRadius: BorderRadius.circular(
                                    6.0), // Match the radius to `enabledBorder`
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'venue name'),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Fixed Footer
        const AppFooter(),
      ],
    );
  }
}
