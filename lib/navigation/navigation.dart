import 'package:aiverse_labs/screens/ChatScreen/ChatScreen.dart';
import 'package:aiverse_labs/screens/mainTab/HomeScreen/HomeScreenController.dart';
import 'package:aiverse_labs/screens/mainTab/NavBar/NavBArWrapper.dart';
import 'package:get/get.dart';

import 'routername.dart';

class Pages {
  static List<GetPage> pages() {
    return [
      GetPage(
        name: RouterName.homeScreen,
        page: () => const Navbarwrapper(),
        binding: HomeScreenControllerBinding(),
      ),
      GetPage(
        name: RouterName.chatScreen,
        page: () => ChatScreen(expert: Get.arguments),
      ),
    ];
  }
}
