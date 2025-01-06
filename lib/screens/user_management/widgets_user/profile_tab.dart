import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/providers/providers.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/profiletab/business_name.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/profiletab/job_title_field.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/profiletab/name_field.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/profiletab/password_field.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/profiletab/user_email_field.dart';
import 'package:aureola_platform/screens/user_management/widgets_user/profiletab/user_phone_number.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _businessNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _jobTitleController = TextEditingController(text: user?.jobTitle ?? '');
    _businessNameController =
        TextEditingController(text: user?.businessName ?? '');
    _phoneNumberController =
        TextEditingController(text: user?.contact.phoneNumber ?? '');
    _emailController = TextEditingController(text: user?.contact.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _businessNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;

        // Set container width based on breakpoints
        double containerWidth;
        if (screenWidth >= Breakpoints.desktop) {
          // Desktop screens
          containerWidth = 600; // Fixed max width for a nice look
        } else if (screenWidth >= 600) {
          // Tablet screens
          containerWidth = 500;
        } else {
          // Mobile screens
          containerWidth = double.infinity;
        }

        return SingleChildScrollView(
          child: Center(
            child: Container(
              width: containerWidth,
              margin: const EdgeInsets.all(16.0),
              decoration:
                  screenWidth >= 800 ? AppThemeLocal.cardDecoration : null,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate("Profile_Information"),
                    style: AppThemeLocal.dropdownItemText,
                  ),
                  const SizedBox(height: 16),

                  // Personal Info Fields
                  NameField(
                      width: double.infinity, controller: _nameController),
                  const SizedBox(height: 16),
                  JobTitleField(
                      width: double.infinity, controller: _jobTitleController),
                  const SizedBox(height: 16),
                  BusinessNameField(
                      width: double.infinity,
                      controller: _businessNameController),

                  const SizedBox(height: 24),
                  Divider(
                      color: AppThemeLocal.accent.withOpacity(0.5),
                      thickness: 0.5),
                  const SizedBox(height: 24),

                  // Login Info Section
                  Text(
                    AppLocalizations.of(context)!
                        .translate('login_information'),
                    style: AppThemeLocal.dropdownItemText,
                  ),
                  const SizedBox(height: 16),
                  UserEmailField(
                      width: double.infinity,
                      controller: _emailController,
                      enabled: false),
                  const SizedBox(height: 16),
                  UserPhoneNumberField(
                      width: containerWidth,
                      controller: _phoneNumberController), // Updated usage

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle verify phone number
                    },
                    child: Text(AppLocalizations.of(context)!
                        .translate('verify_phone_number')),
                  ),

                  const SizedBox(height: 20),
                  const PasswordField(width: double.infinity),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle change password
                    },
                    child: Text(AppLocalizations.of(context)!
                        .translate('change_password')),
                  ),

                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _saveUserInfo(user);
                      },
                      child:
                          Text(AppLocalizations.of(context)!.translate('save')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveUserInfo(UserModel user) async {
    final updatedData = {
      'name': _nameController.text,
      'jobTitle': _jobTitleController.text,
      'businessName': _businessNameController.text,
      'contact.phoneNumber': _phoneNumberController.text,
    };

    await ref.read(userProvider.notifier).updateUserData(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.translate('changes_saved_successfully'),
        ),
      ),
    );
  }
}
