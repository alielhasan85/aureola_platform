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

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        bool isTabletOrDesktop = screenWidth >= 768;
        double fieldWidth = isTabletOrDesktop ? 400 : double.infinity;
        EdgeInsetsGeometry padding = isTabletOrDesktop
            ? const EdgeInsets.all(32.0)
            : const EdgeInsets.all(16.0);

        return SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.translate('user_profile'),
                    style: AppTheme.tabBarItemText),
                const SizedBox(height: 10),
                _buildPersonalInfoCard(
                    context, user, fieldWidth, isTabletOrDesktop),
                const SizedBox(height: 20),
                Text(
                    AppLocalizations.of(context)!
                        .translate('login_information'),
                    style: AppTheme.tabBarItemText),
                const SizedBox(height: 10),
                _buildLoginInfoCard(
                    context, user, fieldWidth, isTabletOrDesktop),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, UserModel user,
      double fieldWidth, bool isTabletOrDesktop) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: isTabletOrDesktop
            ? const EdgeInsets.all(24.0)
            : const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              context,
              label: AppLocalizations.of(context)!.translate("Name"),
              controller: _nameController,
              width: fieldWidth,
              hintText: AppLocalizations.of(context)!.translate("Name_"),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              label: AppLocalizations.of(context)!.translate('Job_Title'),
              controller: _jobTitleController,
              width: fieldWidth,
              hintText: AppLocalizations.of(context)!.translate('Job_Title'),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context,
              label: AppLocalizations.of(context)!.translate('Company_Name'),
              controller: _businessNameController,
              width: fieldWidth,
              hintText: AppLocalizations.of(context)!.translate('Company_Name'),
            ),
            const SizedBox(height: 20),
            _buildSaveButton(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginInfoCard(BuildContext context, UserModel user,
      double fieldWidth, bool isTabletOrDesktop) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: isTabletOrDesktop
            ? const EdgeInsets.all(24.0)
            : const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email field (non-editable)
            _buildTextField(
              context,
              label: AppLocalizations.of(context)!.translate('Email_'),
              controller: _emailController,
              width: fieldWidth,
              hintText: AppLocalizations.of(context)!.translate('Email'),
              enabled: false,
            ),
            const SizedBox(height: 20),
            // Phone number field
            _buildTextField(
              context,
              label: AppLocalizations.of(context)!.translate('Phone_Number'),
              controller: _phoneNumberController,
              width: fieldWidth,
              hintText: AppLocalizations.of(context)!.translate('Phone_Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle verify phone number
              },
              child: Text(AppLocalizations.of(context)!
                  .translate('verify_phone_number')),
            ),
            const SizedBox(height: 20),
            // Password field (non-editable) with change password button
            _buildPasswordField(context, fieldWidth, isTabletOrDesktop),
            const SizedBox(height: 20),
            _buildSaveButton(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required double width,
    required String hintText,
    bool enabled = true,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          label,
          style: AppTheme.paragraph,
        ),
        const SizedBox(height: 6),
        TextField(
          style: AppTheme.paragraph,
          cursorColor: AppTheme.accent,
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          decoration: AppTheme.textFieldinputDecoration(
            hint: hintText,
          ),
        ),
      ]),
    );
  }

  Widget _buildPasswordField(
      BuildContext context, double width, bool isTabletOrDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          context,
          label: AppLocalizations.of(context)!.translate('Password'),
          controller: TextEditingController(text: '********'),
          width: width,
          hintText: '********',
          enabled: false,
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Handle change password
          },
          child:
              Text(AppLocalizations.of(context)!.translate('change_password')),
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

    // Update the user data in Firestore
    await ref.read(userProvider.notifier).updateUserData(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!
            .translate('changes_saved_successfully')),
      ),
    );
  }
}
