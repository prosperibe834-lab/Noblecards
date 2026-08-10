import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_text_styles.dart';
import 'providers/edit_profile_provider.dart';
import 'widgets/editable_text_field.dart';
import 'widgets/edit_profile_shimmer.dart';
import 'widgets/image_source_bottom_sheet.dart';
import 'widgets/info_banner.dart';
import 'widgets/profile_photo_picker.dart';
import 'package:country_picker/country_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String? selectedField;

  const EditProfileScreen({super.key, this.selectedField});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileProvider>().loadProfileData();
    });
  }

  void _showImagePickerModal(BuildContext context) {
    final provider = context.read<EditProfileProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ImageSourceBottomSheet(
        onCameraTap: () async {
          final success = await provider.takePhotoWithCamera();
          if (!success && provider.errorMessage != null && mounted) {
            _showSnackBar(provider.errorMessage!, isError: true);
          }
        },
        onGalleryTap: () async {
          final success = await provider.pickImageFromGallery();
          if (!success && provider.errorMessage != null && mounted) {
            _showSnackBar(provider.errorMessage!, isError: true);
          }
        },
        onRemoveTap: () {
          provider.removePhoto();
        },
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reset Changes?',
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to discard all changes and revert back to your original profile data?',
          style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<EditProfileProvider>().resetChanges();
              _showSnackBar('Changes reset to original profile data.');
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
  }

  Future<void> _selectDateOfBirth(BuildContext context, EditProfileProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2001, 7, 12),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formatted = "${picked.day} ${_monthName(picked.month)} ${picked.year}";
      provider.updateDateOfBirth(formatted);
    }
  }

  String _monthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  void _selectGender(BuildContext context, EditProfileProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Male', 'Female', 'Prefer not to say'].map((option) {
            return ListTile(
              title: Text(option, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
              onTap: () {
                provider.updateGender(option);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<EditProfileProvider>();
    final profile = provider.profile;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: isDark ? Colors.white : Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: AppTextStyles.h3.copyWith(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: provider.isLoading
          ? const EditProfileShimmer()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    // Profile Photo
                    ProfilePhotoPicker(
                      photoPath: profile.photoPath,
                      onTap: () => _showImagePickerModal(context),
                    ),
                    const SizedBox(height: 24),

                    // Personal Information Container Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Boxicons.bx_user, color: AppColors.success, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          EditableTextField(
                            label: 'Full Name',
                            value: profile.fullName,
                            leadingIcon: Boxicons.bx_user,
                            onChanged: provider.updateFullName,
                            validator: (val) => (val == null || val.isEmpty) ? 'Name cannot be empty' : null,
                          ),
                          EditableTextField(
                            label: 'Username',
                            value: profile.username,
                            leadingIcon: Boxicons.bx_at,
                            onChanged: provider.updateUsername,
                            validator: (val) => (val == null || val.length < 3) ? 'Username too short' : null,
                          ),
                          EditableTextField(
                            label: 'Email Address',
                            value: profile.email,
                            leadingIcon: Boxicons.bx_envelope,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: provider.updateEmail,
                            validator: (val) => (val == null || !val.contains('@')) ? 'Invalid email' : null,
                          ),
                          EditableTextField(
                            label: 'Phone Number',
                            value: profile.phone,
                            leadingIcon: Boxicons.bx_phone,
                            keyboardType: TextInputType.phone,
                            onChanged: provider.updatePhone,
                            validator: (val) => (val == null || val.isEmpty) ? 'Phone required' : null,
                          ),
                          EditableTextField(
                            label: 'Country',
                            value: profile.country,
                            leadingIcon: Boxicons.bx_globe,
                            isDropdown: true,
                            onTap: () {
                              final isDarkPicker = Theme.of(context).brightness == Brightness.dark;
                              showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                favorite: const ['NG', 'US', 'GB', 'CA'],
                                countryListTheme: CountryListThemeData(
                                  backgroundColor: isDarkPicker ? AppColors.darkCard : AppColors.lightCard,
                                  borderRadius: BorderRadius.circular(AppRadius.xl),
                                  bottomSheetHeight: 520,
                                  inputDecoration: InputDecoration(
                                    hintText: 'Search country',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppRadius.md),
                                    ),
                                  ),
                                ),
                                onSelect: (Country country) {
                                  provider.updateCountry(country.name);
                                },
                              );
                            },
                          ),
                          EditableTextField(
                            label: 'Date of Birth',
                            value: profile.dateOfBirth,
                            leadingIcon: Boxicons.bx_calendar,
                            isDropdown: true,
                            onTap: () => _selectDateOfBirth(context, provider),
                          ),
                          EditableTextField(
                            label: 'Gender',
                            value: profile.gender,
                            leadingIcon: Boxicons.bx_user,
                            isDropdown: true,
                            onTap: () => _selectGender(context, provider),
                          ),
                          EditableTextField(
                            label: 'Address',
                            value: profile.address,
                            leadingIcon: Boxicons.bx_map,
                            isMultiline: true,
                            onChanged: provider.updateAddress,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Security Info Banner
                    const InfoBanner(),
                    const SizedBox(height: 24),

                    // Save Changes Button (Green Gradient)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: provider.isFormValid && provider.hasChanges
                              ? const LinearGradient(
                                  colors: [Color(0xFF0F9B0F), Color(0xFF0A6C0A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: !(provider.isFormValid && provider.hasChanges)
                              ? (isDark ? Colors.white12 : Colors.grey.shade300)
                              : null,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: provider.isFormValid && provider.hasChanges
                              ? [
                                  BoxShadow(
                                    color: AppColors.success.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: ElevatedButton(
                          onPressed: (provider.isFormValid && provider.hasChanges && !provider.isSaving)
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await provider.saveChanges();
                                    if (success && mounted) {
                                      _showSnackBar('Profile updated successfully.');
                                    }
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: provider.isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Boxicons.bx_save, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Save Changes',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Reset Changes Button (Outlined)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: provider.hasChanges
                            ? () => _showResetConfirmationDialog(context)
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark ? Colors.white24 : Colors.grey.shade300,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Boxicons.bx_refresh,
                              color: isDark ? Colors.white : Colors.black87,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reset Changes',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}