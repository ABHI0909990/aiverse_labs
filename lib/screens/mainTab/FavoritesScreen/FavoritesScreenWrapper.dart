import 'package:aiverse_labs/screens/mainTab/HomeScreen/HomeScreenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../constant/font_family.dart';
import '../../../customWIdgets/AIExpertCard/AIExpertCard .dart';
import '../../../customWIdgets/GradientAppBar.dart';
import '../../BaseViewController/baseController.dart';
import 'FavoritesScreenController.dart';

class FavoritesScreen extends BaseView<FavoritesScreenController> {
  const FavoritesScreen({super.key});

  @override
  Widget vBuilder(BuildContext context) {
    final HomeScreenController homeController = HomeScreenController();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Favorite Experts',
        titleStyle: TextStyle(
          fontFamily: AppFonts.family2SemiBold,
          fontSize: 18.sp,
          color: theme.textTheme.titleLarge?.color,
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.favoriteExperts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Your Favorites List is Empty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the heart icon on any expert to add them to your favorites',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.favoriteExperts.length,
          itemBuilder: (context, index) {
            final expert = controller.favoriteExperts[index];
            return GestureDetector(
              onTap: () => _onExpertSelected(expert, context),
              child: AIExpertCard(
                name: expert['name'] as String,
                expertise: expert['expertise'] as String,
                rating: expert['rating'] as String,
                imageUrl: expert['image'] as String,
                proOnly: expert['proOnly'] as bool,
                description: expert['description'] as String,
                isFavorite: true, // Always true in favorites screen
                onFavoriteToggle: () => controller.removeFromFavorites(expert),
                onNavigateToChatSection: () =>
                    homeController.onExpertSelected(expert, context),
              ),
            );
          },
        );
      }),
    );
  }

  void _onExpertSelected(Map<String, dynamic> expert, BuildContext context) {
    final bool isProOnly = expert['proOnly'] as bool;
    if (!isProOnly || controller.isProUser) {
      Get.toNamed('/chat', arguments: expert);
    } else {
      _showProUpgradeDialog(context, expert);
    }
  }

  void _showProUpgradeDialog(
      BuildContext context, Map<String, dynamic> expert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pro badge with gradient
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'PRO EXCLUSIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Expert image
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(expert['image'] as String),
                ),
                SizedBox(height: 16),

                // Expert name and message
                Text(
                  expert['name'] as String,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Unlock premium conversations with our top AI experts',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 20),

                // Benefits list
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pro Membership Benefits:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildBenefitRow(Icons.verified,
                          'Advanced AI responses with deeper insights'),
                      _buildBenefitRow(Icons.upload_file,
                          'Unlimited file uploads for analysis'),
                      _buildBenefitRow(Icons.speed,
                          'Priority processing and faster responses'),
                      _buildBenefitRow(
                          Icons.support_agent, 'Premium customer support'),
                      _buildBenefitRow(Icons.people,
                          'Access to all expert AI personalities'),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Not Now'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        print('Navigating to subscription page');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Upgrade to Pro',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build benefit rows in the pro upgrade dialog
  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
