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
    selectedIndex.value = index;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void changeFilterTab(int index) {
    selectedTab.value = index;
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
      'expertise': 'AI & Machine Learning Engineering',
      'rating': '4.9',
      'image': AppImages.ethanHarper,
      'proOnly': false,
      'collegeDegree': 'Computer Science',
      'description':
          'Senior AI Engineer specializing in deep learning, neural networks, and computer vision. Expert in PyTorch, TensorFlow, and model optimization. Can help with AI model development, training, and deployment.',
      'availability': 'Available',
      'experience': '10 years',
      'languages': ['English', 'Spanish'],
      'hourlyRate': 95,
      'responseTime': 'Within 1 hour'
    },
    {
      'name': 'Olivia Bennett',
      'expertise': 'AI Ethics & Responsible AI',
      'rating': '4.9',
      'image': AppImages.oliviaBennett,
      'proOnly': false,
      'collegeDegree': 'Computer Science',
      'description':
          'AI Ethics Specialist focusing on responsible AI development, bias mitigation, and ethical AI governance. Expert in AI safety, fairness, and transparency. Helps organizations implement ethical AI practices.',
      'availability': 'Available',
      'experience': '8 years',
      'languages': ['English', 'French'],
      'hourlyRate': 90,
      'responseTime': 'Within 2 hours'
    },
    {
      'name': 'Noah Sullivan',
      'expertise': 'Cloud Architecture & Distributed Systems',
      'rating': '4.9',
      'image': AppImages.noahSullivan,
      'proOnly': true,
      'collegeDegree': 'Computer Science',
      'description':
          'Cloud Architect specializing in scalable distributed systems, microservices architecture, and cloud-native applications. Expert in AWS, Azure, and GCP. Helps design and optimize cloud infrastructure.',
      'availability': 'Busy',
      'experience': '12 years',
      'languages': ['English', 'German'],
      'hourlyRate': 120,
      'responseTime': 'Within 3 hours'
    },
    {
      'name': 'Lucas Reed',
      'expertise': 'Full-Stack Development & Web Architecture',
      'rating': '4.9',
      'image': AppImages.lucasReed,
      'proOnly': false,
      'collegeDegree': 'Information Technology',
      'description':
          'Full-stack developer specializing in modern web technologies. Expert in React, Vue, Node.js, and cloud deployment. Helps build scalable web applications and optimize performance.',
      'availability': 'Available',
      'experience': '9 years',
      'languages': ['English', 'Portuguese'],
      'hourlyRate': 85,
      'responseTime': 'Within 1 hour'
    },
    {
      'name': 'Ava Patel',
      'expertise': 'Cybersecurity & Ethical Hacking',
      'rating': '4.9',
      'image': AppImages.avaPatel,
      'proOnly': true,
      'collegeDegree': 'Information Technology',
      'description':
          'Cybersecurity expert specializing in penetration testing, security architecture, and threat intelligence. Certified ethical hacker with expertise in network security and incident response.',
      'availability': 'Available',
      'experience': '11 years',
      'languages': ['English', 'Hindi'],
      'hourlyRate': 110,
      'responseTime': 'Within 2 hours'
    },
    {
      'name': 'Liam Foster',
      'expertise': 'Mobile App Development & UI/UX',
      'rating': '4.8',
      'image': AppImages.liamFoster,
      'proOnly': true,
      'collegeDegree': 'Engineering',
      'description':
          'Mobile development specialist focusing on Flutter, React Native, and native iOS/Android. Expert in mobile UI/UX design, performance optimization, and app architecture.',
      'availability': 'Busy',
      'experience': '7 years',
      'languages': ['English'],
      'hourlyRate': 90,
      'responseTime': 'Within 4 hours'
    },
    {
      'name': 'Sarah Chen',
      'expertise': 'Data Science & Machine Learning',
      'rating': '4.9',
      'image': AppImages.isabellaHayes,
      'proOnly': true,
      'collegeDegree': 'Computer Science',
      'description':
          'Data Scientist specializing in machine learning, statistical analysis, and big data processing. Expert in Python, R, and data visualization. Helps organizations leverage data for insights.',
      'availability': 'Available',
      'experience': '10 years',
      'languages': ['English', 'Mandarin'],
      'hourlyRate': 105,
      'responseTime': 'Within 2 hours'
    },
    {
      'name': 'Marcus Johnson',
      'expertise': 'DevOps & Cloud Infrastructure',
      'rating': '4.9',
      'image': AppImages.danielCarter,
      'proOnly': true,
      'collegeDegree': 'Information Technology',
      'description':
          'DevOps Engineer specializing in CI/CD, infrastructure as code, and cloud automation. Expert in Kubernetes, Docker, and cloud platforms. Helps streamline development and deployment processes.',
      'availability': 'Available',
      'experience': '9 years',
      'languages': ['English', 'Spanish'],
      'hourlyRate': 100,
      'responseTime': 'Within 3 hours'
    },
    {
      'name': 'Priya Sharma',
      'expertise': 'Blockchain & Web3 Development',
      'rating': '4.8',
      'image': AppImages.graceMitchell,
      'proOnly': true,
      'collegeDegree': 'Computer Science',
      'description':
          'Blockchain developer specializing in smart contracts, DeFi, and Web3 applications. Expert in Solidity, Ethereum, and decentralized systems. Helps build secure blockchain solutions.',
      'availability': 'Busy',
      'experience': '8 years',
      'languages': ['English', 'Hindi'],
      'hourlyRate': 115,
      'responseTime': 'Within 4 hours'
    },
    {
      'name': 'Alex Rivera',
      'expertise': 'Game Development & Graphics Programming',
      'rating': '4.8',
      'image': AppImages.henryParker,
      'proOnly': true,
      'collegeDegree': 'Computer Science',
      'description':
          'Game developer specializing in Unity, Unreal Engine, and graphics programming. Expert in game physics, 3D modeling, and real-time rendering. Helps create immersive gaming experiences.',
      'availability': 'Available',
      'experience': '7 years',
      'languages': ['English', 'Spanish'],
      'hourlyRate': 95,
      'responseTime': 'Within 2 hours'
    },
    {
      'name': 'Yuki Tanaka',
      'expertise': 'Robotics & Embedded Systems',
      'rating': '4.9',
      'image': AppImages.sophiaTurner,
      'proOnly': true,
      'collegeDegree': 'Engineering',
      'description':
          'Robotics engineer specializing in embedded systems, control systems, and automation. Expert in ROS, Arduino, and real-time systems. Helps develop robotic solutions and automation systems.',
      'availability': 'Available',
      'experience': '9 years',
      'languages': ['English', 'Japanese'],
      'hourlyRate': 110,
      'responseTime': 'Within 3 hours'
    },
    {
      'name': 'David Kim',
      'expertise': 'Quantum Computing & Cryptography',
      'rating': '4.9',
      'image': AppImages.benjaminCollins,
      'proOnly': true,
      'collegeDegree': 'Computer Science',
      'description':
          'Quantum computing researcher specializing in quantum algorithms and cryptography. Expert in quantum programming and post-quantum cryptography. Helps organizations prepare for quantum computing.',
      'availability': 'Busy',
      'experience': '12 years',
      'languages': ['English', 'Korean'],
      'hourlyRate': 130,
      'responseTime': 'Within 4 hours'
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
