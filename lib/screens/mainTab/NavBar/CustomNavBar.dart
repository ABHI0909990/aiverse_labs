import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/assets.dart';
import '../../../constant/font_family.dart';
import '../HomeScreen/HomeScreenController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/physics.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    // Listen to index changes
    widget.homeScreenController.selectedIndex.listen((index) {
      _animateIndicatorToIndex(index);
    });
  }

  void _animateIndicatorToIndex(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
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
    _indicatorController.forward(from: 0);
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 4;

    return Container(
      height: 80.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Animated indicator
            AnimatedBuilder(
              animation: _indicatorPosition,
              builder: (context, child) {
                return Positioned(
                  left: _indicatorPosition.value,
                  child: Container(
                    width: itemWidth,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                );
              },
            ),
            // Navigation items
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _labels.length,
                    (index) => _buildNavItem(
                      context,
                      index: index,
                      label: _labels[index],
                      icon: _icons[index],
                      isSelected:
                          widget.homeScreenController.selectedIndex.value ==
                              index,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required String label,
    required String icon,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 4;

    return GestureDetector(
      onTap: () => widget.homeScreenController.changeTab(index),
      child: Container(
        width: itemWidth,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: _buildNavIcon(icon, isSelected, theme),
            ),
            SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: AppFonts.family2Medium,
                fontSize: 12,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(String iconPath, bool isSelected, ThemeData theme) {
    return AnimatedScale(
      scale: isSelected ? 1.2 : 1.0,
      duration: Duration(milliseconds: 200),
      curve: Curves.elasticOut,
      child: Image.asset(
        iconPath,
        width: 24,
        height: 24,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.6),
        errorBuilder: (context, error, stackTrace) {
          // Fallback to Material Icons if asset fails to load
          IconData fallbackIcon;
          switch (iconPath) {
            case AppImages.home:
              fallbackIcon = Icons.home;
              break;
            case AppImages.heart:
              fallbackIcon = Icons.favorite;
              break;
            case AppImages.search:
              fallbackIcon = Icons.search;
              break;
            case AppImages.profile:
              fallbackIcon = Icons.person;
              break;
            default:
              fallbackIcon = Icons.circle;
          }

          return Icon(
            fallbackIcon,
            size: 24,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.6),
          );
        },
      ),
    );
  }
}

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  const AnimatedGradientBackground({required this.child, Key? key})
      : super(key: key);

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _color1 = ColorTween(
      begin: Colors.blue.shade200,
      end: Colors.purple.shade200,
    ).animate(_controller);

    _color2 = ColorTween(
      begin: Colors.pink.shade100,
      end: Colors.orange.shade100,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_color1.value!, _color2.value!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class WiggleOnError extends StatefulWidget {
  final bool hasError;
  final Widget child;
  const WiggleOnError({required this.hasError, required this.child, Key? key})
      : super(key: key);

  @override
  State<WiggleOnError> createState() => _WiggleOnErrorState();
}

class _WiggleOnErrorState extends State<WiggleOnError>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _offset = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));
  }

  @override
  void didUpdateWidget(covariant WiggleOnError oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offset.value, 0),
          child: widget.child,
        );
      },
    );
  }
}

class PulsingFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget icon;
  const PulsingFAB({required this.onPressed, required this.icon, Key? key})
      : super(key: key);

  @override
  State<PulsingFAB> createState() => _PulsingFABState();
}

class _PulsingFABState extends State<PulsingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        child: widget.icon,
      ),
    );
  }
}
