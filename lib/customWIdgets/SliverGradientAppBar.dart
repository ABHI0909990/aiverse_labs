import 'package:flutter/material.dart';
import '../constant/color.dart';

class SliverGradientAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final bool stretch;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? titlePadding;
  final List<Widget>? decorativeElements;

  const SliverGradientAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.elevation = 0,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.titleSpacing,
    this.expandedHeight = 120,
    this.pinned = true,
    this.floating = false,
    this.stretch = true,
    this.titleStyle,
    this.titlePadding,
    this.decorativeElements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultTitleStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      color: isDark ? AppColors.white : AppColors.primaryTextColor,
    );

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      stretch: stretch,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: titlePadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Row(
          children: [
            Text(
              title,
              style: titleStyle ?? defaultTitleStyle,
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
                      const Color(0xFF2C2C2C),
                      AppColors.darkBackgroundColor,
                    ]
                  : [
                      AppColors.white,
                      AppColors.primaryColor.withOpacity(0.05),
                    ],
            ),
            boxShadow: elevation > 0
                ? [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: elevation * 3,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
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
              if (decorativeElements != null) ...decorativeElements!,
            ],
          ),
        ),
      ),
    );
  }
}