import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkle/core/constants/app_images.dart';
import '../../../../core/utils/translation_helper.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildHeader(),
              SizedBox(height: screenHeight * 0.02),
              _buildProfileCard(),
              SizedBox(height: screenHeight * 0.04),
              _buildAccountSettingsSection(),
              SizedBox(height: screenHeight * 0.04),
              _buildSignOutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Profile',
      style: TextStyle(
        fontSize: AppConstants.titleHomeSize,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 95,
                height: 95,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.fromBorderSide(
                    BorderSide(color: AppColors.border, width: 2),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Image.asset(
                      AppImages.edit,
                    scale: 4.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Ralph Edwards',
            style: TextStyle(
              fontSize: AppConstants.mediumFontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '(+44) 012 - 456 - 789',
            style: TextStyle(
              fontSize: AppConstants.mediumFontSize,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Tr.accountSetting,
          style: const TextStyle(
            fontSize: AppConstants.mediumFontSize,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        _buildSettingsItem(
          iconPath: AppImages.profileIcon,
          title: Tr.personalInformation,
          onTap: () => controller.navigateToPersonalInfo(),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        _buildSettingsItem(
          iconPath: AppImages.card,
          title: Tr.billingInformation,
          onTap: () => controller.navigateToBillingInfo(),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        _buildSettingsItem(
          iconPath: AppImages.language,
          title: Tr.language,
          onTap: () => controller.showLanguageDialog(),
        ),
      ],
    );
  }

  Widget _buildSignOutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Tr.signOut,
          style: const TextStyle(
            fontSize: AppConstants.mediumFontSize,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        _buildSettingsItem(
          iconPath: AppImages.logout,
          title: Tr.signOut,
          onTap: () => controller.signOut(),
          iconColor: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  scale: 4,
                  width: 20,
                  height: 20,
                  color: iconColor ?? AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: AppConstants.defaultFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
