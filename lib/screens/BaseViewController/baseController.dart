// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BaseController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoading = false.obs;
  final localStorage = GetStorage();
}

abstract class BaseViewModel<T extends BaseController> extends StatelessWidget {
  const BaseViewModel({super.key});

  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag);

  @override
  Widget vBuilder(BuildContext context) {
    return Obx(() => vmBuilder());
  }

  Widget vmBuilder();
}

abstract class BaseView<T extends BaseController> extends StatelessWidget {
  const BaseView({super.key});

  final String? tag = null;
  T get controller => GetInstance().find<T>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      builder: (controller) {
        return vBuilder(context);
      },
    );
  }

  Widget vBuilder(BuildContext context);
}
