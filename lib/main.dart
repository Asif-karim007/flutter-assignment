import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/post_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/services/api_service.dart';
import 'core/services/storage_service.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final apiService = ApiService();

  Get.put<StorageService>(storageService, permanent: true);
  Get.put<ApiService>(apiService, permanent: true);

  final themeController = Get.put<ThemeController>(
    ThemeController(storageService),
    permanent: true,
  );
  await themeController.loadTheme();

  final authController = Get.put<AuthController>(
    AuthController(apiService, storageService),
    permanent: true,
  );
  await authController.restoreSession();

  Get.put<ProductController>(ProductController(apiService), permanent: true);
  Get.put<PostController>(PostController(apiService), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'DummyJSON App',
        debugShowCheckedModeBanner: false,
        themeMode: themeController.themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        initialRoute: authController.isLoggedIn ? AppRoutes.home : AppRoutes.login,
        getPages: AppRoutes.pages,
      );
    });
  }
}
