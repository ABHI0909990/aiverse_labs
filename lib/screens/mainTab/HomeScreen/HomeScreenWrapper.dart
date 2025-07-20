import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../constant/font_family.dart';
import '../../../customWIdgets/AIExpertCard/AIExpertCard .dart';
import '../../../customWIdgets/SliverGradientAppBar.dart';
import '../../BaseViewController/baseController.dart';
import '../FavoritesScreen/FavoritesScreenController.dart';
import 'HomeScreenController.dart';
import 'package:get/get.dart';

class HomeScreen extends BaseView<HomeScreenController> {
  final FavoritesScreenController _favoritesController =
      Get.find<FavoritesScreenController>();

  HomeScreen({super.key});

  @override
  Widget vBuilder(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 800));
          return;
        },
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverGradientAppBar(
              title: 'AI Experts',
              expandedHeight: 120,
              titleStyle: TextStyle(
                fontFamily: AppFonts.family2Bold,
                fontSize: 20.sp,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 60,
                maxHeight: 60,
                child: _buildFilterTabs(context, theme),
              ),
            ),
            _buildExpertsList(context, theme),
          ],
        ),
      ),
      floatingActionButton: _buildProButton(context, theme),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme, bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Row(
          children: [
            Text(
              'AI Experts',
              style: TextStyle(
                fontFamily: AppFonts.family2Bold,
                fontSize: 20.sp,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      theme.scaffoldBackgroundColor,
                      theme.scaffoldBackgroundColor.withOpacity(0.8),
                    ]
                  : [
                      Colors.white,
                      theme.colorScheme.primary.withOpacity(0.05),
                    ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                bottom: 20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, ThemeData theme) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.collegeDegrees.length,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              final isSelected = controller.selectedTab.value == index;
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.changeFilterTab(index),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withOpacity(0.8),
                                ],
                              )
                            : null,
                        color: isSelected
                            ? null
                            : theme.cardColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        controller.collegeDegrees[index],
                        style: TextStyle(
                          fontFamily: isSelected
                              ? AppFonts.family2SemiBold
                              : AppFonts.family2Regular,
                          fontSize: 14.sp,
                          color: isSelected
                              ? Colors.white
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget _buildExpertsList(BuildContext context, ThemeData theme) {
    return Obx(() {
      if (controller.filteredExperts.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 48,
                  color: theme.colorScheme.primary.withOpacity(0.5),
                ),
                SizedBox(height: 16),
                Text(
                  'No experts found',
                  style: TextStyle(
                    fontFamily: AppFonts.family2Medium,
                    fontSize: 18.sp,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Try changing your filter',
                  style: TextStyle(
                    fontFamily: AppFonts.family2Regular,
                    fontSize: 14.sp,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: EdgeInsets.all(16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final expert = controller.filteredExperts[index];

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500 + (index * 50)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => controller.onExpertSelected(expert, context),
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
                              controller.onExpertSelected(expert, context),
                        )),
                  ),
                ),
              );
            },
            childCount: controller.filteredExperts.length,
          ),
        ),
      );
    });
  }

  Widget _buildProButton(BuildContext context, ThemeData theme) {
    return Obx(() {
      final isProUser = controller.isProUser;

      return Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.8, end: 1.0),
          duration: Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: FloatingActionButton.extended(
            onPressed: () {
              if (isProUser) {
                controller.cancelProSubscription();
              } else {
                controller.activateProSubscription(1);
              }
            },
            backgroundColor: isProUser
                ? theme.colorScheme.secondary
                : theme.colorScheme.primary,
            elevation: 8,
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                isProUser ? Icons.star : Icons.star_border,
                key: ValueKey<bool>(isProUser),
              ),
            ),
            label: Text(
              isProUser ? 'Cancel Pro' : 'Activate Pro',
              style: TextStyle(
                fontFamily: AppFonts.family2SemiBold,
                fontSize: 14.sp,
              ),
            ),
            tooltip: isProUser
                ? 'Cancel Pro subscription'
                : 'Activate Pro subscription',
          ),
        ),
      );
    });
  }

  void _toggleFavorite(Map<String, dynamic> expert) {
    if (_favoritesController.isInFavorites(expert)) {
      _favoritesController.removeFromFavorites(expert);
    } else {
      _favoritesController.addToFavorites(expert);
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
