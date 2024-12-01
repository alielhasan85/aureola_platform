import 'package:aureola_platform/models/user/user_model.dart';
import 'package:aureola_platform/providers/user_provider.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

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
    double width = 300;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Profile', style: AppTheme.tabBarItemText),
            const SizedBox(height: 10),
            _buildPersonalInfoCard(context, user, width),
            const SizedBox(height: 20),
            Text('Login Information', style: AppTheme.tabBarItemText),
            const SizedBox(height: 10),
            _buildLoginInfoCard(context, user, width),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(
      BuildContext context, UserModel user, double width) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate("Name"),
                      style: AppTheme.paragraph,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      style: AppTheme.paragraph,
                      cursorColor: AppTheme.accent,
                      controller: _nameController,
                      decoration: AppTheme.textFieldinputDecoration(
                        hint: AppLocalizations.of(context)!.translate("Name_"),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('Job_Title'),
                      style: AppTheme.paragraph,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      style: AppTheme.paragraph,
                      cursorColor: AppTheme.accent,
                      controller: _jobTitleController,
                      decoration: AppTheme.textFieldinputDecoration(
                        hint: AppLocalizations.of(context)!
                            .translate('Job_Title'),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate(
                        'Company_Name',
                      ),
                      style: AppTheme.paragraph,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      style: AppTheme.paragraph,
                      cursorColor: AppTheme.accent,
                      controller: _jobTitleController,
                      decoration: AppTheme.textFieldinputDecoration(
                        hint: AppLocalizations.of(context)!.translate(
                          'Company _Name',
                        ),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            _buildSaveButton(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginInfoCard(
      BuildContext context, UserModel user, double width) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email field (non-editable)
            SizedBox(
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate(
                        'Email_',
                      ),
                      style: AppTheme.paragraph,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      style: AppTheme.paragraph,
                      cursorColor: AppTheme.accent,
                      controller: _emailController,
                      decoration: AppTheme.textFieldinputDecoration(
                        hint: AppLocalizations.of(context)!.translate(
                          'Email',
                        ),
                      ),
                    ),
                  ]),
            ),

            const SizedBox(height: 20),
            // Phone number field
            SizedBox(
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate(
                        'Phone_Number',
                      ),
                      style: AppTheme.paragraph,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      style: AppTheme.paragraph,
                      cursorColor: AppTheme.accent,
                      controller: _phoneNumberController,
                      decoration: AppTheme.textFieldinputDecoration(
                        hint: AppLocalizations.of(context)!.translate(
                          'Phone_Number',
                        ),
                      ),
                    ),
                  ]),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle verify phone number
              },
              // style: AppTheme.buttonStyle,
              child: const Text('Verify Phone Number'),
            ),
            const SizedBox(height: 20),
            // Password field (non-editable) with change password button
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate(
                              'Password',
                            ),
                            style: AppTheme.paragraph,
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            style: AppTheme.paragraph,
                            cursorColor: AppTheme.accent,
                            obscureText: true,
                            enabled: false,
                            controller: TextEditingController(text: '********'),
                            decoration: AppTheme.textFieldinputDecoration(
                              hint: AppLocalizations.of(context)!.translate(
                                'Phone_Number',
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle change password
                  },
                  // style: AppTheme.buttonStyle,
                  child: const Text('Change Password'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSaveButton(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, UserModel user) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () async {
          await _saveUserInfo(user);
        },
        // style: AppTheme.buttonStyle,
        child: const Text('Save'),
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

    // Update the user data in Firestore
    await ref.read(userProvider.notifier).updateUserData(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully!')),
    );
  }
}
