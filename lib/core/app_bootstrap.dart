import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';

class AppBootstrap {
  static Future<String> init() async {
    final storage = Get.isRegistered<StorageService>()
        ? Get.find<StorageService>()
        : StorageService();
    await storage.init();

    final api = Get.isRegistered<ApiService>() ? Get.find<ApiService>() : ApiService();

    if (!Get.isRegistered<StorageService>()) {
      Get.put<StorageService>(storage, permanent: true);
    }
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(api, permanent: true);
    }

    final theme = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : Get.put<ThemeController>(ThemeController(storage), permanent: true);
    await theme.loadTheme();

    final auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put<AuthController>(AuthController(api, storage), permanent: true);
    await auth.restoreSession();

    if (!Get.isRegistered<ProductController>()) {
      Get.put<ProductController>(ProductController(api), permanent: true);
    }
    if (!Get.isRegistered<PostController>()) {
      Get.put<PostController>(PostController(api), permanent: true);
    }

    return auth.isLoggedIn ? AppRoutes.home : AppRoutes.login;
  }
}
