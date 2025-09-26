import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkle/core/constants/app_colors.dart';
import 'package:sparkle/features/home/presentation/views/home_view.dart';
import '../../../../core/utils/logger.dart';
import '../../../profile/presentation/views/profile_view.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;
  
  // Pages for bottom navigation
  late final List<Widget> pages;

  @override
  void onInit() {
    super.onInit();
    _initializePages();
    Logger.i('MainController initialized');
  }

  void _initializePages() {
    pages = [
      _buildHomePage(),
      _buildPhonePage(),
      _buildProfilePage(),
    ];
  }

  Widget _buildHomePage() {
    return const HomeView();
  }

  Widget _buildPhonePage() {
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Text(
          'Phone Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return const ProfileView();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
    Logger.d('Navigation changed to index: $index');
  }
}
