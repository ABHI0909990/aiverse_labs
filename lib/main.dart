import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'constant/app_themes.dart';
import 'models/theme_model.dart';
import 'navigation/navigation.dart';
import 'navigation/routername.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final ThemeModel themeModel = ThemeModel();
  themeModel.listenToSystemThemeChanges();

  runApp(MyApp(themeModel: themeModel));
}

class MyApp extends StatelessWidget {
  final ThemeModel themeModel;

  const MyApp({
    super.key,
    required this.themeModel,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return Obx(() => GetMaterialApp(
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode:
                themeModel.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
            initialRoute: RouterName.homeScreen,
            debugShowCheckedModeBanner: false,
            getPages: Pages.pages(),
          ));
    });
  }
}
