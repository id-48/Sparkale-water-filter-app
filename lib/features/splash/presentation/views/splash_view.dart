import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/translation_helper.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.waterGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: AppConstants.largeImageSize,
                height: AppConstants.largeImageSize,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppConstants.extraLargeRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.water_drop,
                  size: AppConstants.extraLargeIconSize,
                  color: AppColors.waterBlue,
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // App Name
              Text(
                Tr.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.smallPadding),
              
              // App Subtitle
              Text(
                Tr.splashSubtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.extraLargePadding),
              
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
