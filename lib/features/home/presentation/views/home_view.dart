import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/translation_helper.dart';
import '../../../../core/services/json_translation_service.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Tr.homeTitle),
        actions: [
          // Language Switcher
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String languageCode) {
              JsonTranslationService.to.changeLanguage(languageCode);
            },
            itemBuilder: (BuildContext context) {
              return JsonTranslationService.to.availableLanguages.map((language) {
                return PopupMenuItem<String>(
                  value: language['code']!,
                  child: Row(
                    children: [
                      Text(language['nativeName']!),
                      const SizedBox(width: AppConstants.smallPadding),
                      if (JsonTranslationService.to.currentLanguage == language['code'])
                        const Icon(Icons.check, color: AppColors.primary),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop,
                              color: AppColors.waterBlue,
                              size: AppConstants.largeIconSize,
                            ),
                            const SizedBox(width: AppConstants.defaultPadding),
                            Expanded(
                              child:                         Text(
                          Tr.welcomeMessage,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        Text(
                          'Welcome to the Sparkale Water Filter App! This is a demo counter to show GetX state management working.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppConstants.largePadding),
                
                // Counter Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Tr.counterDemo,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        Center(
                          child: Obx(() => Text(
                            '${controller.counter.value}',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                        const SizedBox(height: AppConstants.largePadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: controller.decrementCounter,
                              icon: const Icon(Icons.remove),
                              label: Text(Tr.decrease),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: controller.resetCounter,
                              icon: const Icon(Icons.refresh),
                              label: Text(Tr.reset),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.grey,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: controller.incrementCounter,
                              icon: const Icon(Icons.add),
                              label: Text(Tr.increase),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppConstants.largePadding),
                
                // Features Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Tr.appFeatures,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        _buildFeatureItem(
                          context,
                          Icons.architecture,
                          Tr.mvcArchitecture,
                          Tr.mvcArchitectureDesc,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.speed,
                          Tr.getxStateManagement,
                          Tr.getxStateManagementDesc,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.storage,
                          Tr.localStorage,
                          Tr.localStorageDesc,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.palette,
                          Tr.customTheme,
                          Tr.customThemeDesc,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.language,
                          Tr.multiLanguage,
                          Tr.multiLanguageDesc,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: AppConstants.defaultIconSize,
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
