import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _dropAlertsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softgrey,
      body: SafeArea(
        child: Column(
          children: [
            // 1. App Bar
          Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: AppStyles.heading2.copyWith(fontSize: 22),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 0.8,
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Positioned(
                        top: 13,
                        right: 11.5,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.terracotta,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            // 2. Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Card
                    _buildUserCard(),
                    const SizedBox(height: 24),

                    // Section 1: ACCOUNT SETTINGS
                    _buildSectionHeader('ACCOUNT SETTINGS'),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _buildSettingsTile(
                        icon: Icons.inventory_2_outlined,
                        title: 'Decant Orders',
                        subtitle: 'Track shipments & past samplings',
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.location_on_outlined,
                        title: 'Delivery Addresses',
                        subtitle: 'Primary: Al Olaya District, Riyadh',
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.credit_card_outlined,
                        title: 'Payment Vault',
                        subtitle: 'Visa ending in •••• 4281',
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Section 2: PREFERENCES & CONCIERGE
                    _buildSectionHeader('PREFERENCES & CONCIERGE'),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _buildSwitchTile(
                        icon: Icons.notifications_none_outlined,
                        title: 'Drop Alerts',
                        subtitle: 'Rare extrait restocks & dispatch news',
                        value: _dropAlertsEnabled,
                        onChanged: (val) {
                          setState(() {
                            _dropAlertsEnabled = val;
                          });
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.translate_outlined,
                        title: 'Language',
                        subtitle: 'English & العربية supported',
                        trailingBadge: 'English (EN)',
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.support_agent_outlined,
                        title: 'Decant Concierge & FAQs',
                        subtitle: 'Authentication guarantee & help',
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.verified_user_outlined,
                        title: 'Authenticity & Privacy',
                        subtitle: '100% genuine decanted extraits',
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Logout Button
                    _buildLogoutButton(context),

                    const SizedBox(height: 24),

                    // Footer App Info
                    _buildFooterInfo(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // User Profile Info Card ---
  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          // User Avatar Circle
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFEBCAC1), 
            child: const Text(
              'AM',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8A4B38),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alaa Mamdoh',
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'alaaMamdouh@gmail.com',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Edit Profile Button
          _buildCircleIconButton(
            icon: Icons.edit_outlined,
            size: 38,
            iconSize: 18,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // --- Section Headers ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  // --- Settings Card Container ---
  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: tiles,
      ),
    );
  }

  // --- Standard Tile Item ---
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingBadge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Rounded Icon Box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 20, color: Colors.black87),
            ),
            const SizedBox(width: 14),

            // Titles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Elements
            if (trailingBadge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trailingBadge,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // --- Switch Tile Item ---
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      Transform.scale(
                scale: 0.9, 
                child: Switch(
                  value: value,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.terracotta,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                  onChanged: onChanged,
                ),
              )
        ],
      ),
    );
  }

  // --- Logout Button ---
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          //logout method
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Color(0xFFD94343),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Logout of Account',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD94343),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Footer Application Version ---
  Widget _buildFooterInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GARRIB DECANTS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: AppColors.terracotta,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.circle, size: 4, color: Colors.grey),
            ),
            Text(
              'EDITION 2.4.1',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Bottled and sealed with quality grade care',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // --- Helper Circle Icon Button ---
  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 42,
    double iconSize = 20,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.black, size: iconSize),
        onPressed: onTap,
      ),
    );
  }
}