import 'package:aureola_platform/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VenueAddressField extends ConsumerStatefulWidget {
  final double width;
  final TextEditingController addressController;

  const VenueAddressField({
    super.key,
    required this.width,
    required this.addressController,
  });

  @override
  ConsumerState<VenueAddressField> createState() => _VenueAddressFieldState();
}

class _VenueAddressFieldState extends ConsumerState<VenueAddressField> {
  @override
  Widget build(BuildContext context) {
    final venue = ref.read(draftVenueProvider);
    widget.addressController.text = venue?.address.displayAddress ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.translate("Detailed_address"),
                style: AppThemeLocal.paragraph,
              ),
              const SizedBox(height: 6),
              TextField(
                onChanged: (text) {
                  ref
                      .read(draftVenueProvider.notifier)
                      .updateAddress(newDisplayAddress: text);
                },
                style: AppThemeLocal.paragraph,
                cursorColor: AppThemeLocal.accent,
                controller: widget.addressController,
                decoration: AppThemeLocal.textFieldinputDecoration().copyWith(
                  hintText:
                      AppLocalizations.of(context)!.translate("enter_address"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
