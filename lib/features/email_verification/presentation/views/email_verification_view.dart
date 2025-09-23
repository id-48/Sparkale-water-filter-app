import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_images.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationView extends GetView<EmailVerificationController> {
  const EmailVerificationView({super.key});

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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_outlined,
              color: AppColors.textSecondary,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              'Back to log in',
              style: TextStyle(
                fontSize: AppConstants.mediumFontSize,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
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
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Icon(
            Icons.phone_android,
            color: AppColors.primary.withValues(alpha: 0.8),
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return const Text(
      'Verify your email id',
      style: TextStyle(
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
            const TextSpan(
              text: 'Enter the code we\'ve sent to your email address in ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                fontSize: AppConstants.mediumFontSize,
              ),
            ),
            TextSpan(
              text: controller.userEmail.value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                fontSize: AppConstants.mediumFontSize,
              ),
            ),
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
            otpPinFieldDecoration: OtpPinFieldDecoration.underlinedPinBoxDecoration,
            otpPinFieldStyle: const OtpPinFieldStyle(
              hintText: '0',
              activeFieldBorderColor:AppColors.primary,
              fieldBorderRadius: 0,
              fieldBorderWidth: 0,
              hintTextColor: AppColors.grey,
              textStyle:  TextStyle(
                fontSize: AppConstants.largeFontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ),
            ),
            autoFocus: true,
            autoFillEnable: true,
            showCursor: false,

            keyboardType: TextInputType.number,
            onChange: (value) => controller.onOTPChanged(value),
            onSubmit: (value) => controller.onOTPCompleted(value),
          ),
        ),
        Obx(
          () => controller.otpError.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    controller.otpError.value,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
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
              : const Text(
                  'Verify OTP',
                  style: TextStyle(
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
          const Text(
            'Didn\'t receive the email?',
            style: TextStyle(
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
                  ? 'Click to resend'
                  : 'Code resend after ${controller.resendCountdown.value}',
              style: TextStyle(
                fontSize: AppConstants.mediumFontSize,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                decoration: controller.canResend.value
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
