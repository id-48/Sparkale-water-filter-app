import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/utils/translation_helper.dart';
import '../../../../core/utils/status_bar_util.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    StatusBarUtil.setStatusBarStyle();

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
                SizedBox(height: screenHeight * 0.08),
                _buildLoginTitleSection(),
                SizedBox(height: screenHeight * 0.06),
                _buildEmailInputSection(),
                SizedBox(height: screenHeight * 0.03),
                _buildSendOtpButton(),
                // SizedBox(height: screenHeight * 0.03),
                // _buildDivider(),
                // SizedBox(height: screenHeight * 0.03),
                // _buildGoogleSignInButton(),
                SizedBox(height: screenHeight * 0.06),
                _buildSignUpLink(),
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

  Widget _buildLoginTitleSection() {
    return Column(
      children: [
        Text(
          Tr.loginTitle,
          style: const TextStyle(
            fontSize: AppConstants.titleFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          Tr.loginSubtitle,
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

  Widget _buildEmailInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                controller.isEmailInput.value ? Tr.email : Tr.mono,
                style: const TextStyle(
                  fontSize: AppConstants.defaultFontSize,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.toggleInputType,
              child: Obx(
                () => Text(
                  controller.isEmailInput.value
                      ? Tr.useMobileNumber
                      : Tr.useEmail,
                  style: const TextStyle(
                    fontSize: AppConstants.defaultFontSize,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Obx(
          () => CustomTextField(
            key: ValueKey(controller.isEmailInput.value),
            controller: controller.emailController,
            hintText: controller.isEmailInput.value
                ? Tr.enterEmail
                : Tr.enterPhoneNumber,
            keyboardType: controller.isEmailInput.value
                ? TextInputType.emailAddress
                : TextInputType.number,
            maxLength: controller.isEmailInput.value ? null : 10,
            validator: controller.validateEmailOrPhone,
            prefixIcon: controller.isEmailInput.value
                ? null
                : CountryCodePicker(
                    onChanged: (CountryCode countryCode) {
                      controller.selectCountry(countryCode);
                    },
                    initialSelection: 'IN',
                    favorite: const ['+91', 'IN'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    showDropDownButton: true,
                    showFlag: true,
                    hideMainText: true,
                    flagWidth: 30,
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
          ),
        ),
      ],
    );
  }

  Widget _buildSendOtpButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.sendOtp(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text(
                  Tr.sendOtp,
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

  // Widget _buildGoogleSignInButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 56,
  //     child: OutlinedButton(
  //       onPressed: controller.signInWithGoogle,
  //       style: OutlinedButton.styleFrom(
  //         backgroundColor: AppColors.white,
  //         foregroundColor: AppColors.textSecondary,
  //         side: const BorderSide(color: AppColors.border),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
  //         ),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             width: 20,
  //             height: 20,
  //             decoration: const BoxDecoration(
  //               image: DecorationImage(
  //                 image: NetworkImage(
  //                   'https://developers.google.com/identity/images/g-logo.png',
  //                 ),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: AppConstants.defaultPadding),
  //            Text(
  //             Tr.signInWithGoogle,
  //             style: const TextStyle(
  //               fontSize: AppConstants.mediumFontSize,
  //               fontWeight: FontWeight.w400,
  //               color: AppColors.textSecondary,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Tr.dontHaveAccount,
          style: const TextStyle(
            fontSize: AppConstants.defaultFontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        GestureDetector(
          onTap: controller.navigateToSignUp,
          child: Text(
            Tr.signUp,
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
