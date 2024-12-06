import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profiletab/business_name.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profiletab/job_title_field.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profiletab/name_field.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profiletab/password_field.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profiletab/user_email_field.dart';
import 'package:aureola_platform/screens/user_management.dart/widgets_user/profiletab/user_phone_number.dart';
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

    final screenWidth = MediaQuery.of(context).size.width;

    // Determine container width based on breakpoints
    double containerWidth;
    if (screenWidth >= Breakpoints.desktop) {
      containerWidth = screenWidth * 0.5;
    } else if (screenWidth >= Breakpoints.tablet) {
      containerWidth = screenWidth * 0.7;
    } else {
      containerWidth = double.infinity; // Full width on mobile
    }

    final isTabletOrDesktop = screenWidth >= Breakpoints.tablet;

    return Column(
      children: [
        // TODO: username dynamic from firebase

        Expanded(
          child: Padding(
            padding: isTabletOrDesktop
                ? const EdgeInsets.symmetric(horizontal: 20)
                : EdgeInsets.zero,
            child: Container(
              width: containerWidth,
              margin: EdgeInsets.symmetric(
                vertical: isTabletOrDesktop ? 30 : 12,
              ),
              decoration: isTabletOrDesktop ? AppTheme.cardDecoration : null,
              child: SingleChildScrollView(
                child: Padding(
                    padding: isTabletOrDesktop
                        ? const EdgeInsets.symmetric(horizontal: 30)
                        : const EdgeInsets.symmetric(horizontal: 10),
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
                            Padding(
                              padding:
                                  EdgeInsets.all(columns > 1 ? 24.0 : 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Personal Info Section
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("Profile_Information"),
                                    style: AppTheme.tabBarItemText,
                                  ),
                                  const SizedBox(height: 16),
                                  NameField(
                                      width: fieldWidth,
                                      controller: _nameController),
                                  JobTitleField(
                                      width: fieldWidth,
                                      controller: _jobTitleController),
                                  BusinessNameField(
                                      width: fieldWidth,
                                      controller: _businessNameController),

                                  const SizedBox(height: 24),
                                  Divider(
                                      color: AppTheme.accent.withOpacity(0.5),
                                      thickness: 0.5),
                                  const SizedBox(height: 24),

                                  // Login Info Section
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('login_information'),
                                    style: AppTheme.tabBarItemText,
                                  ),
                                  const SizedBox(height: 16),
                                  UserEmailField(
                                      width: fieldWidth,
                                      controller: _emailController,
                                      enabled: false),
                                  UserPhoneNumberField(
                                      width: fieldWidth,
                                      controller: _phoneNumberController),

                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle verify phone number
                                    },
                                    child: Text(AppLocalizations.of(context)!
                                        .translate('verify_phone_number')),
                                  ),

                                  const SizedBox(height: 20),
                                  PasswordField(width: fieldWidth),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle change password
                                    },
                                    child: Text(AppLocalizations.of(context)!
                                        .translate('change_password')),
                                  ),

                                  const SizedBox(height: 20),
                                  _buildSaveButton(context, user),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, UserModel user) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () async {
          await _saveUserInfo(user);
        },
        child: Text(AppLocalizations.of(context)!.translate('save')),
      ),
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
        content: Text(AppLocalizations.of(context)!
            .translate('changes_saved_successfully')),
      ),
    );
  }
}
