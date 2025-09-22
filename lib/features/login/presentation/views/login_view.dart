import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.04),
              _buildLogoSection(context),
              SizedBox(height: screenHeight * 0.06),
              _buildLoginTitleSection(),
              SizedBox(height: screenHeight * 0.06),
              _buildEmailInputSection(),
              SizedBox(height: screenHeight * 0.03),
              _buildSendOtpButton(),
              SizedBox(height: screenHeight * 0.03),
              _buildDivider(),
              SizedBox(height: screenHeight * 0.03),
              _buildGoogleSignInButton(),
              SizedBox(height: screenHeight * 0.06),
              _buildSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppImages.splashLogo,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.07,
        ),
      ],
    );
  }

  Widget _buildLoginTitleSection() {
    return const Column(
      children: [
        Text(
          AppStrings.loginTitle,
          style: TextStyle(
            fontSize: AppConstants.titleFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppConstants.smallPadding),
        Text(
          AppStrings.loginSubtitle,
          style: TextStyle(
            fontSize: AppConstants.mediumFontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.email,
              style: TextStyle(
                fontSize: AppConstants.defaultFontSize,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: controller.toggleInputType,
              child: const Text(
                AppStrings.useMobileNumber,
                style: TextStyle(
                  fontSize: AppConstants.defaultFontSize,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Obx(() => TextFormField(
          controller: controller.emailController,
          keyboardType: controller.isEmailInput.value 
              ? TextInputType.emailAddress 
              : TextInputType.phone,
          decoration: InputDecoration(
            hintText: controller.isEmailInput.value 
                ? AppStrings.enterEmail 
                : AppStrings.enterMobileNumber,
            hintStyle: const TextStyle(
              color: AppColors.textHint,
              fontSize: AppConstants.defaultFontSize,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.defaultPadding,
            ),
          ),
        )),
      ],
    );
  }
  Widget _buildSendOtpButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.sendOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
        ),
        child: const Text(
          AppStrings.sendOtp,
          style: TextStyle(
            fontSize: AppConstants.mediumFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              color: AppColors.border,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          child: Text(
            AppStrings.or,
            style: TextStyle(
              fontSize: AppConstants.defaultFontSize,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              color: AppColors.border,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: controller.signInWithGoogle,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://developers.google.com/identity/images/g-logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            const Text(
              AppStrings.signInWithGoogle,
              style: TextStyle(
                fontSize: AppConstants.mediumFontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.dontHaveAccount,
          style: TextStyle(
            fontSize: AppConstants.defaultFontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        GestureDetector(
          onTap: controller.navigateToSignUp,
          child: const Text(
            AppStrings.signUp,
            style: TextStyle(
              fontSize: AppConstants.defaultFontSize,
              color: AppColors.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
