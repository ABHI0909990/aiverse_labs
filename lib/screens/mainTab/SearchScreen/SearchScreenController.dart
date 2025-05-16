import 'package:get/get.dart';

import '../../../models/subscription_model.dart';
import '../../BaseViewController/baseController.dart';
import '../HomeScreen/HomeScreenController.dart';

class SearchScreenControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchScreenController());
  }
}

class SearchScreenController extends BaseController {
  final SubscriptionModel _subscriptionModel = SubscriptionModel();
  final HomeScreenController _homeController = Get.find<HomeScreenController>();

  final RxString searchQuery = ''.obs;
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;

  bool get isProUser => _subscriptionModel.hasProAccess;

  List<Map<String, dynamic>> get allExperts => _homeController.experts;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
    } else {
      _performSearch(query);
    }
  }

  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();

    final results = allExperts.where((expert) {
      final name = (expert['name']?.toString() ?? '').toLowerCase();
      final expertise = (expert['expertise']?.toString() ?? '').toLowerCase();

      return name.contains(lowerQuery) || expertise.contains(lowerQuery);
    }).toList();

    searchResults.value = results;
  }

  bool hasAccessToExpert(Map<String, dynamic> expert) {
    final bool isProOnly = expert['proOnly'] as bool? ?? false;
    return !isProOnly || isProUser;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }
}
