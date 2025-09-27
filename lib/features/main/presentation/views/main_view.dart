import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Removed AppStrings in favor of Tr translations
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/translation_helper.dart';
import '../../../../core/constants/app_images.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.transprent,
          body: Obx(() => controller.pages[controller.currentIndex.value]),
          bottomNavigationBar: _buildBottomNavigation(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              iconPath: AppImages.home,
              label: Tr.homeTitle,
              index: 0,
              isSelected: controller.currentIndex.value == 0,
            ),
            _buildNavItem(
              iconPath: AppImages.call,
              label: Tr.support,
              index: 1,
              isSelected: controller.currentIndex.value == 1,
            ),
            _buildNavItem(
              iconPath: AppImages.profile,
              label: Tr.profile,
              index: 2,
              isSelected: controller.currentIndex.value == 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    String? iconPath,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    if (isSelected) {
      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Asset image for selected items
              Image.asset(
                iconPath!,
                width: 20,
                height: 20,
                color: AppColors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: Image.asset(
          iconPath!,
          width: 24,
          height: 24,
          color: AppColors.white,
        ),
      );
    }
  }
}
