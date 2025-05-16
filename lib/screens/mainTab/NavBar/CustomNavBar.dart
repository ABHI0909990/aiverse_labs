import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:get/get.dart';
import '../../../constant/assets.dart';
import '../../../constant/font_family.dart';
import '../HomeScreen/HomeScreenController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomNavBar extends StatefulWidget {
  final HomeScreenController homeScreenController;
  final Widget child;

  const CustomNavBar({
    Key? key,
    required this.homeScreenController,
    required this.child,
  }) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar>
    with SingleTickerProviderStateMixin {
  final List<String> _labels = ['Home', 'Favorites', 'Search', 'Profile'];
  final List<String> _icons = [
    AppImages.home,
    AppImages.heart,
    AppImages.search,
    AppImages.profile
  ];

  late AnimationController _indicatorController;
  late Animation<double> _indicatorPosition;

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _indicatorPosition = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _indicatorController,
        curve: Curves.easeOutCubic,
      ),
    );

    ever(widget.homeScreenController.selectedIndex, (index) {
      _animateIndicatorToIndex(index);
    });
  }

  void _animateIndicatorToIndex(int index) {
    final screenWidth = 100.w;
    final itemWidth = screenWidth / 4;
    final newPosition = index * itemWidth;

    _indicatorPosition = Tween<double>(
      begin: _indicatorPosition.value,
      end: newPosition,
    ).animate(
      CurvedAnimation(
        parent: _indicatorController,
        curve: Curves.easeOutCubic,
      ),
    );

    _indicatorController.reset();
    _indicatorController.forward();
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BottomBar(
        fit: StackFit.expand,
        borderRadius: BorderRadius.circular(30),
        barColor: Colors.transparent,
        showIcon: false,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        body: (context, controller) => SafeArea(
          child: widget.child,
        ),
        width: 200.w,
        child: Padding(
          padding: EdgeInsets.only(bottom: 1.5.h, left: 3.w, right: 3.w),
          child: Container(
            height: 11.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        theme.cardColor,
                        theme.cardColor.withOpacity(0.9),
                      ]
                    : [
                        Colors.white,
                        Colors.white.withOpacity(0.9),
                      ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedBuilder(
                      animation: _indicatorController,
                      builder: (context, child) {
                        return Positioned(
                          left: _indicatorPosition.value,
                          top: 0,
                          child: Container(
                            width: 100.w / 4,
                            height: 3,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(3),
                                bottomRight: Radius.circular(3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: -2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        4,
                        (index) => _buildNavItem(
                          imagePath: _icons[index],
                          label: _labels[index],
                          index: index,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String imagePath,
    required String label,
    required int index,
  }) {
    return Obx(() {
      final bool isSelected =
          widget.homeScreenController.selectedIndex.value == index;
      final theme = Theme.of(context);

      return Tooltip(
        message: label,
        preferBelow: false,
        verticalOffset: 20,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.homeScreenController.changeIndex(index),
            borderRadius: BorderRadius.circular(20),
            splashColor: theme.colorScheme.primary.withOpacity(0.1),
            highlightColor: theme.colorScheme.primary.withOpacity(0.05),
            child: Container(
              width: 21.w,
              height: 11.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: isSelected ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 18.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0.8,
                          end: isSelected ? 1.0 : 0.8,
                        ),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Image.asset(
                          imagePath,
                          width: 7.w,
                          height: 3.5.h,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.iconTheme.color?.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 0.8.h),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontFamily: isSelected
                              ? AppFonts.family2SemiBold
                              : AppFonts.family2Regular,
                          fontSize: 12.sp,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                        ),
                        child: Text(label),
                      ),
                    ],
                  ),
                  if (isSelected)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: (1 - value).clamp(0.0, 0.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
