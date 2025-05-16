import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/subscription_model.dart';
import '../../../models/theme_model.dart';
import '../../BaseViewController/baseController.dart';

class ProfileScreenControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileScreenController());
  }
}

class ProfileScreenController extends BaseController {
  final SubscriptionModel _subscriptionModel = SubscriptionModel();
  final ThemeModel _themeModel = ThemeModel();
  final GetStorage _storage = GetStorage();

  final RxString userName = 'Guest User'.obs;
  final RxString userEmail = ''.obs;
  final RxBool isLoggedIn = false.obs;

  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';

  bool get isProUser => _subscriptionModel.hasProAccess;
  DateTime? get subscriptionExpiry => _subscriptionModel.expiryDate.value;
  int get remainingDays => _subscriptionModel.remainingDays;

  bool get isDarkMode => _themeModel.isDarkMode.value;
  bool get useSystemTheme => _themeModel.useSystemTheme.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    userName.value = _storage.read(_userNameKey) ?? 'Guest User';
    userEmail.value = _storage.read(_userEmailKey) ?? '';
    isLoggedIn.value = _storage.read(_isLoggedInKey) ?? false;
  }

  void _saveUserData() {
    _storage.write(_userNameKey, userName.value);
    _storage.write(_userEmailKey, userEmail.value);
    _storage.write(_isLoggedInKey, isLoggedIn.value);
  }

  void updateProfile({required String name, required String email}) {
    userName.value = name;
    userEmail.value = email;
    isLoggedIn.value = true;
    _saveUserData();

    Get.snackbar(
      'Profile Updated',
      'Your profile has been updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signOut() {
    isLoggedIn.value = false;
    _saveUserData();

    Get.snackbar(
      'Signed Out',
      'You have been signed out successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void activateProSubscription(int months) {
    _subscriptionModel.activateProSubscription(months);

    Get.snackbar(
      'Pro Activated',
      'You now have access to all Pro features for $months months!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void cancelProSubscription() {
    _subscriptionModel.cancelProSubscription();

    Get.snackbar(
      'Pro Cancelled',
      'Your Pro subscription has been cancelled.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  // Theme management methods
  void toggleTheme() {
    _themeModel.toggleTheme();

    Get.snackbar(
      'Theme Changed',
      'App theme has been changed to ${_themeModel.isDarkMode.value ? 'Dark' : 'Light'} mode',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setDarkMode(bool value) {
    _themeModel.setDarkMode(value);
  }

  void setUseSystemTheme(bool value) {
    _themeModel.setUseSystemTheme(value);

    Get.snackbar(
      'Theme Setting Changed',
      value
          ? 'App will now follow your system theme'
          : 'System theme following disabled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
