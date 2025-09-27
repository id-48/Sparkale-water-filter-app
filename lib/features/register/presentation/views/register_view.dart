import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/utils/translation_helper.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),
                _buildLogoSection(context),
                SizedBox(height: screenHeight * 0.05),
                _buildRegisterTitleSection(),
                SizedBox(height: screenHeight * 0.06),
                _buildFirstNameInputSection(),
                SizedBox(height: screenHeight * 0.03),
                _buildLastNameInputSection(),
                SizedBox(height: screenHeight * 0.03),
                _buildPhoneNumberInputSection(),
                SizedBox(height: screenHeight * 0.03),
                _buildEmailInputSection(),
                SizedBox(height: screenHeight * 0.03),
                _buildTermsAndConditionsSection(),
                SizedBox(height: screenHeight * 0.06),
                _buildSignUpButton(),
                // SizedBox(height: screenHeight * 0.03),
                // _buildDivider(),
                // SizedBox(height: screenHeight * 0.03),
                // _buildGoogleSignUpButton(),
                SizedBox(height: screenHeight * 0.06),
                _buildSignInLink(),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
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

  Widget _buildRegisterTitleSection() {
    return Column(
      children: [
         Text(
          Tr.registerTitle,
          style: const TextStyle(
            fontSize: AppConstants.titleFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.smallPadding),
         Text(
          Tr.registerSubtitle,
          style: const TextStyle(
            fontSize: AppConstants.defaultFontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFirstNameInputSection() {
    return CustomTextField(
      controller: controller.firstNameController,
      labelText: Tr.firstName,
      hintText: Tr.enterFirstName,
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildLastNameInputSection() {
    return CustomTextField(
      controller: controller.lastNameController,
      labelText: Tr.lastName,
      hintText: Tr.enterLastName,
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildPhoneNumberInputSection() {
    return CustomTextField(
      controller: controller.phoneController,
      labelText: Tr.phoneNumber,
      hintText: Tr.enterPhoneNumber,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      prefixIcon: CountryCodePicker(
        onChanged: controller.onCountryChanged,
        initialSelection: 'IN', // This should match with controller default
        favorite: const ['+91', 'IN'],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
        showDropDownButton: true,
        showFlag: true,
        flagWidth: 20,
        textStyle: const TextStyle(
          fontSize: AppConstants.defaultFontSize,
          color: AppColors.textSecondary,
        ),
        dialogTextStyle: const TextStyle(
          fontSize: AppConstants.defaultFontSize,
          color: AppColors.textSecondary,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildEmailInputSection() {
    return CustomTextField(
      controller: controller.emailController,
      labelText: Tr.email,
      hintText: Tr.enterEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildTermsAndConditionsSection() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: controller.toggleTermsAcceptance,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: controller.isTermsAccepted.value
                    ? AppColors.textSecondary
                    : AppColors.white,
                border: Border.all(
                  color: controller.isTermsAccepted.value
                      ? AppColors.textSecondary
                      : AppColors.border,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: controller.isTermsAccepted.value
                  ? const Icon(Icons.check, size: 14, color: AppColors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: AppConstants.defaultFontSize,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                   TextSpan(
                    text: Tr.byProviding,
                    style: const TextStyle(
                      fontSize: AppConstants.defaultFontSize,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: controller.navigateToTermsOfService,
                      child:  Text(
                        Tr.termsOfService,
                        style: const TextStyle(
                          fontSize: AppConstants.defaultFontSize,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                   TextSpan(
                    text: Tr.and,
                    style: const TextStyle(
                      fontSize: AppConstants.defaultFontSize,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: controller.navigateToPrivacyPolicy,
                      child:  Text(
                        Tr.privacyPolicy,
                        style: const TextStyle(
                          fontSize: AppConstants.defaultFontSize,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                   TextSpan(
                    text: Tr.inuseOfApp,
                    style: const TextStyle(
                      fontSize: AppConstants.defaultFontSize,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.registerUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              :  Text(
                  Tr.signUp,
                  style: const TextStyle(
                    fontSize: AppConstants.mediumFontSize,
                    fontWeight: FontWeight.w600,
                  ),
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
            decoration: const BoxDecoration(color: AppColors.border),
          ),
        ),
         Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: Text(
            Tr.or,
            style: const TextStyle(
              fontSize: AppConstants.defaultFontSize,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(color: AppColors.border),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignUpButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.signUpWithGoogle,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://developers.google.com/identity/images/g-logo.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.defaultPadding),
                     Text(
                      Tr.signInWithGoogle,
                      style: const TextStyle(
                        fontSize: AppConstants.mediumFontSize,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          Tr.alreadyHaveAccount,
          style: const TextStyle(
            fontSize: AppConstants.defaultFontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: controller.navigateToSignUp,
          child:  Text(
            Tr.signIn,
            style: const TextStyle(
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
