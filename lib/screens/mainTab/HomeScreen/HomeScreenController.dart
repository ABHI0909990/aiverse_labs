import 'package:aiverse_labs/constant/assets.dart';
import 'package:aiverse_labs/models/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../BaseViewController/baseController.dart';
import '../FavoritesScreen/FavoritesScreenController.dart';
import '../ProfileScreen/ProfileScreenController.dart';
import '../SearchScreen/SearchScreenController.dart';

class HomeScreenControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
  }
}

class HomeScreenController extends BaseController {
  var selectedIndex = 0.obs;
  RxInt selectedTab = 0.obs;
  final SubscriptionModel _subscriptionModel = SubscriptionModel();

  bool get isProUser => _subscriptionModel.hasProAccess;

  var collegeDegrees = <String>[
    'All',
    'Computer Science',
    'Information Technology',
    'Engineering',
    'Business Administration',
    'Medicine',
  ].obs;

  List<Map<String, dynamic>> get filteredExperts {
    if (selectedTab.value == 0) {
      return experts;
    } else {
      String selectedDegree = collegeDegrees[selectedTab.value];
      return experts
          .where((expert) => expert['collegeDegree'] == selectedDegree)
          .toList();
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  bool hasAccessToExpert(Map<String, dynamic> expert) {
    final bool isProOnly = expert['proOnly'] as bool;
    return !isProOnly || isProUser;
  }

  void onExpertSelected(Map<String, dynamic> expert, BuildContext context) {
    Get.toNamed('/chat', arguments: expert);
  }

  void showProBenefitsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pro Benefits'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upgrade to Pro for enhanced features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• More accurate AI responses with negative prompting'),
              Text('• Unlimited image uploads (Free: 3 per day)'),
              Text('• Faster response times'),
              Text('• Priority support'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to subscription page
                print('Navigating to subscription page');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Upgrade to Pro'),
            ),
          ],
        );
      },
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

  final List<Map<String, dynamic>> experts = [
    {
      'name': 'Ethan Harper',
      'expertise': 'Coding, Machine Learning',
      'rating': '4.8',
      'image': AppImages.ethanHarper,
      'proOnly': false,
      'collegeDegree': 'Computer Science',
      'description':
          'Expert in Python, TensorFlow, and AI model development. Can help with code optimization and AI solutions.'
    },
    {
      'name': 'Olivia Bennett',
      'expertise': 'AI Ethics, Machine Learning',
      'rating': '4.8',
      'image': AppImages.oliviaBennett,
      'proOnly': false,
      'collegeDegree': 'Computer Science',
      'description':
          'Expert in AI ethics, responsible AI development, and machine learning algorithms.'
    },
    {
      'name': 'Noah Sullivan',
      'expertise': 'Database Systems, Cloud Computing',
      'rating': '4.7',
      'image': AppImages.noahSullivan,
      'proOnly': true,
      'collegeDegree': 'Computer Science',
      'description':
          'Specialist in database design, cloud architecture, and scalable distributed systems.'
    },
    {
      'name': 'Lucas Reed',
      'expertise': 'Web Development, JavaScript',
      'rating': '4.9',
      'image': AppImages.lucasReed,
      'proOnly': false,
      'collegeDegree': 'Information Technology',
      'description':
          'Specializes in modern web frameworks like React, Vue, and Angular. Can assist with full-stack development.'
    },
    {
      'name': 'Ava Patel',
      'expertise': 'Network Security, Cybersecurity',
      'rating': '4.9',
      'image': AppImages.avaPatel,
      'proOnly': true,
      'collegeDegree': 'Information Technology',
      'description':
          'Expert in cybersecurity, penetration testing, and network security best practices.'
    },
    {
      'name': 'Liam Foster',
      'expertise': 'Mobile Development, Flutter',
      'rating': '4.7',
      'image': AppImages.liamFoster,
      'proOnly': true,
      'collegeDegree': 'Engineering',
      'description':
          'Expert in Flutter and React Native. Can help with mobile app architecture and optimization.'
    },
    {
      'name': 'Isabella Hayes',
      'expertise': 'UX/UI Design, Product Development',
      'rating': '4.9',
      'image': AppImages.isabellaHayes,
      'proOnly': false,
      'collegeDegree': 'Engineering',
      'description':
          'Specializes in user experience design and product development. Helps create intuitive interfaces.'
    },
    {
      'name': 'Daniel Carter',
      'expertise': 'Mechanical Engineering, Robotics',
      'rating': '4.6',
      'image': AppImages.danielCarter,
      'proOnly': true,
      'collegeDegree': 'Engineering',
      'description': 'Expert in robotics, mechanical design, and automation.'
    },
    {
      'name': 'Grace Mitchell',
      'expertise': 'Business Strategy, Marketing',
      'rating': '4.6',
      'image': AppImages.graceMitchell,
      'proOnly': true,
      'collegeDegree': 'Business Administration',
      'description':
          'Specializes in business strategy, market analysis, and growth marketing.'
    },
    {
      'name': 'Henry Parker',
      'expertise': 'Marketing Analytics, Digital Marketing',
      'rating': '4.8',
      'image': AppImages.henryParker,
      'proOnly': false,
      'collegeDegree': 'Business Administration',
      'description':
          'Specialist in marketing analytics, digital strategies, and consumer behavior.'
    },
    {
      'name': 'Sophia Turner',
      'expertise': 'Healthcare, Medical Research',
      'rating': '4.9',
      'image': AppImages.sophiaTurner,
      'proOnly': true,
      'collegeDegree': 'Medicine',
      'description':
          'Expert in medical research, healthcare systems, and clinical data analysis.'
    },
    {
      'name': 'Benjamin Collins',
      'expertise': 'Clinical Research, Pharmacology',
      'rating': '4.7',
      'image': AppImages.benjaminCollins,
      'proOnly': true,
      'collegeDegree': 'Medicine',
      'description':
          'Expert in pharmacology, drug development, and clinical research.'
    },
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    Get.lazyPut(() => FavoritesScreenController());
    Get.lazyPut(() => ProfileScreenController());
    Get.lazyPut(() => SearchScreenController());
  }
}
