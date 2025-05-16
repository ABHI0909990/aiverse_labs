import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../constant/font_family.dart';
import '../../../customWIdgets/AIExpertCard/AIExpertCard .dart';
import '../../../customWIdgets/GradientAppBar.dart';
import '../../BaseViewController/baseController.dart';
import '../FavoritesScreen/FavoritesScreenController.dart';
import '../HomeScreen/HomeScreenController.dart';
import 'SearchScreenController.dart';

class SearchScreen extends BaseView<SearchScreenController> {
  final FavoritesScreenController _favoritesController =
      Get.find<FavoritesScreenController>();

  SearchScreen({super.key});

  @override
  Widget vBuilder(BuildContext context) {
    final HomeScreenController homeController = HomeScreenController();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Search Experts',
        titleStyle: TextStyle(
          fontFamily: AppFonts.family2SemiBold,
          fontSize: 18.sp,
          color: theme.textTheme.titleLarge?.color,
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search by name or expertise...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: controller.clearSearch,
                      )
                    : SizedBox.shrink()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.searchQuery.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Search for AI Experts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Find experts by name or expertise',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No experts found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try a different search term',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final expert = controller.searchResults[index];
                  return GestureDetector(
                    onTap: () => _onExpertSelected(expert, context),
                    child: Obx(() => AIExpertCard(
                          name: expert['name']?.toString() ?? 'Unknown',
                          expertise:
                              expert['expertise']?.toString() ?? 'General AI',
                          rating: expert['rating']?.toString() ?? '4.0',
                          imageUrl: expert['image']?.toString() ?? '',
                          proOnly: expert['proOnly'] as bool? ?? false,
                          description: expert['description']?.toString() ?? '',
                          isFavorite:
                              _favoritesController.isInFavorites(expert),
                          onFavoriteToggle: () => _toggleFavorite(expert),
                          onNavigateToChatSection: () =>
                              homeController.onExpertSelected(expert, context),
                        )),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _onExpertSelected(Map<String, dynamic> expert, BuildContext context) {
    if (controller.hasAccessToExpert(expert)) {
      Get.toNamed('/chat', arguments: expert);
    } else {
      _showProUpgradeDialog(context, expert);
    }
  }

  void _toggleFavorite(Map<String, dynamic> expert) {
    if (_favoritesController.isInFavorites(expert)) {
      _favoritesController.removeFromFavorites(expert);
    } else {
      _favoritesController.addToFavorites(expert);
    }
  }

  void _showProUpgradeDialog(
      BuildContext context, Map<String, dynamic> expert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pro Feature'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${expert['name']} is only available with a Pro subscription.'),
              SizedBox(height: 8),
              Text(
                'Pro subscription gives you:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• More accurate AI responses'),
              Text('• Unlimited file uploads'),
              Text('• Faster response times'),
              Text('• Priority support'),
              Text('• Access to all AI experts'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('Navigating to subscription page');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Upgrade to Pro'),
            ),
          ],
        );
      },
    );
  }
}
