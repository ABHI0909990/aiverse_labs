import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/subscription_model.dart';
import '../../BaseViewController/baseController.dart';

class FavoritesScreenControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesScreenController());
  }
}

class FavoritesScreenController extends BaseController {
  final SubscriptionModel _subscriptionModel = SubscriptionModel();
  final GetStorage _storage = GetStorage();
  final RxList<Map<String, dynamic>> favoriteExperts =
      <Map<String, dynamic>>[].obs;

  static const String _favoritesKey = 'favorite_experts';

  bool get isProUser => _subscriptionModel.hasProAccess;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void _loadFavorites() {
    final List<dynamic>? storedFavorites = _storage.read(_favoritesKey);
    if (storedFavorites != null) {
      favoriteExperts.value = List<Map<String, dynamic>>.from(storedFavorites);
    }
  }

  void _saveFavorites() {
    _storage.write(_favoritesKey, favoriteExperts.toList());
  }

  void addToFavorites(Map<String, dynamic> expert) {
    final bool alreadyExists =
        favoriteExperts.any((e) => e['name'] == expert['name']);
    if (!alreadyExists) {
      favoriteExperts.add(expert);
      _saveFavorites();
      Get.snackbar(
        'Expert Added',
        'You\'ve added ${expert['name']} to your favorites list',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeFromFavorites(Map<String, dynamic> expert) {
    favoriteExperts.removeWhere((e) => e['name'] == expert['name']);
    _saveFavorites();
    Get.snackbar(
      'Expert Removed',
      'You\'ve removed ${expert['name']} from your favorites list',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool isInFavorites(Map<String, dynamic> expert) {
    return favoriteExperts.any((e) => e['name'] == expert['name']);
  }
}
