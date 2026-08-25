import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../authentication/services/authentication_service.dart';
import 'edit_profile_screen.dart';
import 'providers/edit_profile_provider.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> with SingleTickerProviderStateMixin {
  final AuthenticationService _auth = AuthenticationService();
  AuthUser? _user;
  bool _isLoading = true;
  bool _imageLoadFailed = false;
  String? _errorMessage;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _loadProfile();
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await _loadProfile(showError: true);
  }

  Future<void> _loadProfile({bool showError = false}) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      await _auth.getUserProfile('current');
      if (!mounted) return;
      setState(() {
        _user = _auth.currentUser;
        _imageLoadFailed = false;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load your profile. Please try again.';
      });
      if (showError) _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    final message = _errorMessage;
    if (message == null || message.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _value(String? value) => value?.trim() ?? '';

  String get _fullName {
    final user = _user;
    if (user == null) return '';
    return [user.firstName, user.lastName]
        .where((value) => value.trim().isNotEmpty)
        .join(' ');
  }

  String _formatDateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
  }

  String? _profileImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value.startsWith('/')
        ? '${AuthenticationService.apiBaseUrl}$value'
        : value;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Boxicons.bx_check_circle, color: Color(0xFF00C853), size: 20),
            const SizedBox(width: 10),
            Text(
              'User ID copied to clipboard',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToEditProfile([String? selectedField]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<EditProfileProvider>(
          create: (_) => EditProfileProvider(),
          child: EditProfileScreen(selectedField: selectedField),
        ),
      ),
    ).then((_) => _loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Color Tokens
    final bgColor = isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAF9);
    final cardBg = isDark ? const Color(0xFF141C28) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2F6);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    const primaryGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_chevron_left,
            color: primaryTextColor,
            size: 28,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: Text(
          'Personal Information',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: primaryGreen,
          backgroundColor: cardBg,
          child: _isLoading
              ? _buildShimmerLoading(isDark, cardBg, borderColor)
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      // PROFILE HEADER CARD
                      _buildProfileHeaderCard(
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        primaryGreen: primaryGreen,
                      ),
                      const SizedBox(height: 16),

                      // TOP SECURITY BANNER
                      _buildSecurityBanner(
                        isDark: isDark,
                        icon: Boxicons.bx_shield_quarter,
                        title: 'Keep your information up to date',
                        subtitle: 'This helps us provide you with a secure and seamless experience.',
                        graphicWidget: _buildShieldGraphic(primaryGreen),
                      ),
                      const SizedBox(height: 24),

                      // SECTION TITLE
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(
                          'Personal Information',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // INFORMATION ROWS
                      _buildInfoTile(
                        icon: Boxicons.bx_user,
                        label: 'Full Name',
                        value: _fullName,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        onTap: () => _navigateToEditProfile('Full Name'),
                      ),
                      _buildInfoTile(
                        icon: Boxicons.bx_at,
                        label: 'Username',
                        value: _value(_user?.username),
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        onTap: () => _navigateToEditProfile('Username'),
                      ),
                      _buildInfoTile(
                        icon: Boxicons.bx_envelope,
                        label: 'Email Address',
                        value: _value(_user?.email),
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        onTap: () => _navigateToEditProfile('Email Address'),
                      ),
                      _buildInfoTile(
                        icon: Boxicons.bx_phone,
                        label: 'Phone Number',
                        value: _value(_user?.phone),
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        onTap: () => _navigateToEditProfile('Phone Number'),
                      ),
                      _buildInfoTile(
                        icon: Boxicons.bx_globe,
                        label: 'Country',
                        value: _value(_user?.country),
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        leadingWidget: _buildCountryFlag(_user?.country),
                        onTap: () => _navigateToEditProfile('Country'),
                      ),
                      _buildInfoTile(
                        icon: Boxicons.bx_calendar,
                        label: 'Date of Birth',
                        value: _formatDateOfBirth(_user?.dateOfBirth),
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        onTap: () => _navigateToEditProfile('Date of Birth'),
                      ),
                      _buildInfoTile(
                        icon: Boxicons.bx_user,
                        label: 'Gender',
                        value: _value(_user?.gender),
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        onTap: () => _navigateToEditProfile('Gender'),
                      ),
                      _buildInfoTile(
                        icon: Boxicons.bx_map_pin,
                        label: 'Address',
                        value: _value(_user?.address),
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        onTap: () => _navigateToEditProfile('Address'),
                      ),
                      const SizedBox(height: 16),

                      // BOTTOM SECURITY BANNER
                      _buildSecurityBanner(
                        isDark: isDark,
                        icon: Boxicons.bx_lock_alt,
                        title: 'Your information is private and secure',
                        subtitle: 'We use bank-level encryption to protect your personal data.',
                        graphicWidget: _buildLockGraphic(primaryGreen),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // WIDGET: Profile Header Card
  Widget _buildProfileHeaderCard({
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color primaryGreen,
  }) {
    final imageUrl = _profileImageUrl(_user?.profileImageUrl);
    final backgroundImage = !_imageLoadFailed && imageUrl != null
        ? NetworkImage(imageUrl)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _navigateToEditProfile(),
            child: CircleAvatar(
              radius: 34,
              backgroundColor: primaryGreen.withOpacity(0.1),
              backgroundImage: backgroundImage,
              onBackgroundImageError: backgroundImage == null
                  ? null
                  : (_, __) {
                      if (mounted) setState(() => _imageLoadFailed = true);
                    },
              child: backgroundImage == null
                  ? Icon(Boxicons.bx_user, color: primaryGreen, size: 30)
                  : null,
            ),
          ),
          const SizedBox(width: 14),

          // User Info Details
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToEditProfile(),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Full Name & Verified Badge
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _fullName,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (_user?.isVerified == true)
                        const Icon(
                          Boxicons.bxs_check_circle,
                          color: Color(0xFF10B981),
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Noble Verified Pill
                  if (_user?.isVerified == true)
                    Row(
                      children: [
                        const Icon(
                          Boxicons.bx_shield_quarter,
                          color: Color(0xFF10B981),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Noble Verified',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),

                  // User ID + Copy Icon
                  Row(
                    children: [
                      Text(
                        'User ID: ${_user?.id ?? ''}',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: _user == null ? null : () => _copyToClipboard(_user!.id),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Boxicons.bx_copy,
                            color: secondaryTextColor,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Circular Edit Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _navigateToEditProfile(),
              customBorder: const CircleBorder(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF064E3B).withOpacity(0.5) : const Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Boxicons.bx_pencil,
                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: Security Information Banner
  Widget _buildSecurityBanner({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget graphicWidget,
  }) {
    final bannerBg = isDark
        ? const Color(0xFF082218)
        : const Color(0xFFF0FDF4);
    final border = isDark
        ? const Color(0xFF0F4732)
        : const Color(0xFFDCFCE7);
    final titleColor = isDark
        ? const Color(0xFF34D399)
        : const Color(0xFF059669);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF475569);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Left Icon Shield / Lock
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: titleColor.withOpacity(0.4), width: 1),
            ),
            child: Icon(
              icon,
              color: titleColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Banner Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Decorative Right Graphic
          graphicWidget,
        ],
      ),
    );
  }

  // WIDGET: Information Row Tile
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required VoidCallback onTap,
    Widget? leadingWidget,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon
                leadingWidget ??
                    Icon(
                      icon,
                      color: const Color(0xFF10B981),
                      size: 20,
                    ),
                const SizedBox(width: 12),

                // Label
                Text(
                  label,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),

                // Value
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                const SizedBox(width: 6),

                // Chevron Right
                Icon(
                  Boxicons.bx_chevron_right,
                  color: secondaryTextColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // DECORATIVE: Flag Widget for Country Row
  Widget _buildCountryFlag(String? country) {
    final countryCode = _user?.countryCode?.toUpperCase();
    if (countryCode == null || countryCode.length != 2 || country == null || country.trim().isEmpty) {
      return const SizedBox(width: 20, height: 14);
    }

    final firstLetter = String.fromCharCode(countryCode.codeUnitAt(0) + 127397);
    final secondLetter = String.fromCharCode(countryCode.codeUnitAt(1) + 127397);
    return Container(
      width: 20,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Text(
          '$firstLetter$secondLetter',
          style: const TextStyle(fontSize: 12, height: 1),
        ),
      ),
    );
  }

  // DECORATIVE: Shield Graphic Element
  Widget _buildShieldGraphic(Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Boxicons.bxs_shield,
        color: color,
        size: 24,
      ),
    );
  }

  // DECORATIVE: Lock Graphic Element
  Widget _buildLockGraphic(Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Boxicons.bxs_lock_alt,
        color: color,
        size: 24,
      ),
    );
  }

  // WIDGET: Shimmer Skeleton Loader
  Widget _buildShimmerLoading(bool isDark, Color cardBg, Color borderColor) {
    final baseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final highlightColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Header Card Placeholder
          Container(
            height: 96,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),

          // Banner Placeholder
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 24),

          // Section Title Placeholder
          Container(
            width: 140,
            height: 18,
            margin: const EdgeInsets.only(right: 200, bottom: 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Rows Placeholders
          ...List.generate(
            8,
            (index) => Container(
              height: 52,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}