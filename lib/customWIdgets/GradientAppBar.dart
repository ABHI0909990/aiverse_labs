import 'package:flutter/material.dart';
import '../constant/color.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;
  final PreferredSizeWidget? bottom;
  final TextStyle? titleStyle;

  const GradientAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.elevation = 0,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.titleSpacing,
    this.bottom,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
      child: AppBar(
        title: Text(
          title,
          style: titleStyle ?? Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: actions,
        centerTitle: centerTitle,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        titleSpacing: titleSpacing,
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
