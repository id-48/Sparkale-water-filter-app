import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/utils/translation_helper.dart';
import '../../../../core/utils/status_bar_util.dart';
import '../../presentation/controllers/mobile_verification_controller.dart';

class MobileVerificationView extends GetView<MobileVerificationController> {
  const MobileVerificationView({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.04),
              _buildLogoSection(context),
              SizedBox(height: screenHeight * 0.05),
              _buildBackButton(),
              SizedBox(height: screenHeight * 0.04),
              _buildVerificationIcon(),
              SizedBox(height: screenHeight * 0.04),
              _buildTitleSection(),
              SizedBox(height: screenHeight * 0.02),
              _buildDescriptionSection(),
              SizedBox(height: screenHeight * 0.06),
              _buildOTPInputSection(),
              SizedBox(height: screenHeight * 0.06),
              _buildVerifyButton(),
              SizedBox(height: screenHeight * 0.04),
              _buildResendSection(),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: controller.navigateBack,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_back_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 4),
            Obx(() {
              return Text(
                controller.flow.value == "register"
                    ? Tr.backToRegister
                    : Tr.backToLogin,
                style: const TextStyle(
                  fontSize: AppConstants.mediumFontSize,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              );
            }),
          ],
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

  Widget _buildVerificationIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
        const Icon(Icons.phone_android, color: AppColors.primary, size: 30),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Text(
      Tr.verifyMono,
      style: const TextStyle(
        fontSize: AppConstants.titleFontSize,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescriptionSection() {
    return Obx(
      () => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: AppConstants.defaultFontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: Tr.enterCodeMo,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                fontSize: AppConstants.mediumFontSize,
              ),
            ),
            TextSpan(
              text: ' ${controller.formattedMobileNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                fontSize: AppConstants.mediumFontSize,
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPInputSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: BoxBorder.fromBorderSide(
              BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: OtpPinField(
              maxLength: 6,
              fieldWidth: 37,
              fieldHeight: 40,
              autoFocus: false,
              cursorColor: AppColors.primary,
              highlightBorder: false,
              otpPinFieldStyle: const OtpPinFieldStyle(
                // hintText: '0',
                showHintText: false,
                activeFieldBorderColor: AppColors.white,
                fieldBorderRadius: 0,
                defaultFieldBorderColor: AppColors.white,
                filledFieldBorderColor: AppColors.white,
                fieldBorderWidth: 0,
                hintTextColor: AppColors.grey,
                textStyle: TextStyle(
                  fontSize: AppConstants.largeFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              autoFillEnable: true,
            onCodeChanged: (val){
              // OTP code changed
            },
            onPhoneHintSelected: (val){
              // Phone hint selected
            },
              showCursor: true,
              keyboardType: TextInputType.number,
              onChange: (value) => controller.onOTPChanged(value),
              onSubmit: (String text) {},

          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.verifyOTP,
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
              : Text(
                  Tr.verifyOtp,
                  style: const TextStyle(
                    fontSize: AppConstants.mediumFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Obx(
      () => Column(
        children: [
          Text(
            Tr.codeResendAfter,
            style: const TextStyle(
              fontSize: AppConstants.mediumFontSize,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: controller.canResend.value ? controller.resendOTP : null,
            child: Text(
              controller.canResend.value
                  ? Tr.clickToSend
                  : '00:${controller.resendCountdown.value.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: AppConstants.mediumFontSize,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                decoration: controller.canResend.value
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
