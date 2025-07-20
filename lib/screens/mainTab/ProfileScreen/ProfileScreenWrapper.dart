import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../constant/assets.dart';
import '../../../constant/color.dart';
import '../../../constant/font_family.dart';
import '../../../customWIdgets/GradientAppBar.dart';
import '../../BaseViewController/baseController.dart';
import 'ProfileScreenController.dart';

class ProfileScreen extends BaseView<ProfileScreenController> {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Profile',
        titleStyle: TextStyle(
          fontFamily: AppFonts.family2SemiBold,
          fontSize: 18.sp,
          color: theme.textTheme.titleLarge?.color,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.scaffoldBackgroundColor,
                theme.scaffoldBackgroundColor.withOpacity(0.8),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image with animation
                  Hero(
                    tag: 'profile-image',
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage(AppImages.profilePic),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.5),
                              width: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // User name with animation
                  Obx(() => AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          controller.userName.value,
                          key: ValueKey<String>(controller.userName.value),
                          style: TextStyle(
                            fontFamily: AppFonts.family2Bold,
                            fontSize: 20.sp,
                            shadows: [
                              Shadow(
                                color: theme.shadowColor.withOpacity(0.1),
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      )),
                  SizedBox(height: 8.sp),

                  // User email with animation
                  Obx(() => AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          controller.userEmail.value.isEmpty
                              ? 'No email provided'
                              : controller.userEmail.value,
                          key: ValueKey<String>(controller.userEmail.value),
                          style: TextStyle(
                            fontFamily: AppFonts.family2Regular,
                            fontSize: 16.sp,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      )),
                  SizedBox(height: 32.sp),

                  // Animated cards
                  _buildAnimatedCard(
                    context,
                    index: 0,
                    child: _buildAppearanceCard(context),
                  ),
                  SizedBox(height: 24.sp),

                  _buildAnimatedCard(
                    context,
                    index: 1,
                    child: _buildSubscriptionCard(controller, context),
                  ),
                  SizedBox(height: 32.sp),

                  // Action buttons with animations
                  _buildAnimatedButton(
                    context,
                    index: 2,
                    child: _buildActionButton(
                      context: context,
                      icon: Icons.edit,
                      label: 'Edit Profile',
                      onTap: () => _showEditProfileDialog(context, controller),
                    ),
                  ),
                  SizedBox(height: 16.sp),

                  Obx(() => _buildAnimatedButton(
                        context,
                        index: 3,
                        child: controller.isLoggedIn.value
                            ? _buildActionButton(
                                context: context,
                                icon: Icons.logout,
                                label: 'Sign Out',
                                onTap: () => controller.signOut(),
                              )
                            : _buildActionButton(
                                context: context,
                                icon: Icons.login,
                                label: 'Sign In',
                                onTap: () =>
                                    _showEditProfileDialog(context, controller),
                              ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(BuildContext context,
      {required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildAnimatedButton(BuildContext context,
      {required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(100 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildAppearanceCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 8,
      shadowColor: theme.shadowColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.cardColor,
              theme.cardColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.sp),
                  Text(
                    'Appearance',
                    style: TextStyle(
                      fontFamily: AppFonts.family2Bold,
                      fontSize: 18.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.sp),
              Divider(),
              SizedBox(height: 16.sp),

              // Dark Mode Toggle
              Obx(() => _buildSwitchTile(
                    context,
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    value: controller.isDarkMode,
                    onChanged: (value) {
                      controller.setDarkMode(value);
                    },
                    enabled: !controller.useSystemTheme,
                  )),

              SizedBox(height: 16.sp),

              // System Theme Toggle
              Obx(() => _buildSwitchTile(
                    context,
                    icon: Icons.settings_brightness,
                    title: 'Use System Theme',
                    subtitle: 'Automatically follow your device theme',
                    value: controller.useSystemTheme,
                    onChanged: (value) {
                      controller.setUseSystemTheme(value);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
      decoration: BoxDecoration(
        color: value
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: enabled
                  ? (value
                      ? theme.colorScheme.primary.withOpacity(0.2)
                      : theme.dividerColor.withOpacity(0.1))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: enabled
                  ? (value
                      ? theme.colorScheme.primary
                      : theme.iconTheme.color?.withOpacity(0.7))
                  : theme.iconTheme.color?.withOpacity(0.3),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 16.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.family2Medium,
                    fontSize: 16.sp,
                    color: enabled
                        ? (value
                            ? theme.colorScheme.primary
                            : theme.textTheme.bodyLarge?.color)
                        : theme.textTheme.bodyLarge?.color?.withOpacity(0.5),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.family2Regular,
                      fontSize: 14.sp,
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: theme.colorScheme.primary,
              activeTrackColor: theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
      ProfileScreenController controller, BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() => Card(
          elevation: 8,
          shadowColor: theme.shadowColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.cardColor,
                  theme.cardColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.sp),
                          Text(
                            'Subscription',
                            style: TextStyle(
                              fontFamily: AppFonts.family2Bold,
                              fontSize: 18.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.sp,
                          vertical: 6.sp,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: controller.isProUser
                                ? [
                                    Color(0xFFFF8C00),
                                    Color(0xFFFF2D55),
                                  ]
                                : [
                                    Colors.grey.shade400,
                                    Colors.grey.shade600,
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: controller.isProUser
                                  ? AppColors.primaryColor.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          controller.isProUser ? 'PRO' : 'FREE',
                          style: TextStyle(
                            fontFamily: AppFonts.family2Bold,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.sp),
                  Divider(),
                  SizedBox(height: 16.sp),
                  if (controller.isProUser) ...[
                    _buildSubscriptionDetail(
                      context,
                      'Expiry Date',
                      controller.subscriptionExpiry != null
                          ? '${controller.subscriptionExpiry!.day}/${controller.subscriptionExpiry!.month}/${controller.subscriptionExpiry!.year}'
                          : 'N/A',
                    ),
                    SizedBox(height: 12.sp),
                    _buildSubscriptionDetail(
                      context,
                      'Days Remaining',
                      '${controller.remainingDays} days',
                    ),
                    SizedBox(height: 24.sp),
                    _buildGradientButton(
                      context: context,
                      label: 'Cancel Subscription',
                      icon: Icons.cancel,
                      onTap: () => controller.cancelProSubscription(),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade300,
                          Colors.red.shade700,
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.dividerColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upgrade to Pro to access:',
                            style: TextStyle(
                              fontFamily: AppFonts.family2SemiBold,
                              fontSize: 16.sp,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                          SizedBox(height: 12.sp),
                          _buildProFeature(
                              context, 'More accurate AI responses'),
                          _buildProFeature(context, 'Unlimited file uploads'),
                          _buildProFeature(context, 'Faster response times'),
                          _buildProFeature(context, 'Priority support'),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.sp),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGradientButton(
                            context: context,
                            label: '1 Month',
                            icon: Icons.calendar_month,
                            onTap: () => controller.activateProSubscription(1),
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                Color(0xFFFF2D55),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.sp),
                        Expanded(
                          child: _buildGradientButton(
                            context: context,
                            label: '12 Months',
                            icon: Icons.calendar_today,
                            onTap: () => controller.activateProSubscription(12),
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                Color(0xFFFF2D55),
                              ],
                            ),
                            isBestValue: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildGradientButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required Gradient gradient,
    bool isBestValue = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 48.sp,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.white.withOpacity(0.1),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.sp,
                  vertical: 12.sp,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: AppFonts.family2SemiBold,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isBestValue)
          Positioned(
            top: -10.sp,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.sp,
                vertical: 4.sp,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Best Value',
                style: TextStyle(
                  fontFamily: AppFonts.family2Bold,
                  fontSize: 10.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubscriptionDetail(
      BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family2Regular,
              fontSize: 16.sp,
              color: AppColors.secondaryTextColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.family2SemiBold,
              fontSize: 16.sp,
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProFeature(BuildContext context, String feature) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4.sp),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.blue,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 12.sp),
          Text(
            feature,
            style: TextStyle(
              fontFamily: AppFonts.family2Regular,
              fontSize: 14.sp,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 16.sp,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.sp),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.family2Medium,
                    fontSize: 16.sp,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context, ProfileScreenController controller) {
    final nameController =
        TextEditingController(text: controller.userName.value);
    final emailController =
        TextEditingController(text: controller.userEmail.value);
    final theme = Theme.of(context);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.edit,
              color: theme.colorScheme.primary,
              size: 24.sp,
            ),
            SizedBox(width: 8.sp),
            Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: AppFonts.family2Bold,
                fontSize: 18.sp,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.sp),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppFonts.family2Medium,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateProfile(
                name: nameController.text,
                email: emailController.text,
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.sp,
                vertical: 8.sp,
              ),
            ),
            child: Text(
              'Save',
              style: TextStyle(
                fontFamily: AppFonts.family2SemiBold,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
