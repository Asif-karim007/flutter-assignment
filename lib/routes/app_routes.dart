import 'package:get/get.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/post_detail_page.dart';
import '../pages/product_detail_page.dart';
import '../pages/storyboard_page.dart';

class AppRoutes {
  static const String storyboard = '/storyboard';
  static const String login = '/login';
  static const String home = '/home';
  static const String productDetail = '/product-detail';
  static const String postDetail = '/post-detail';

  static final pages = <GetPage<dynamic>>[
    GetPage(name: storyboard, page: () => const StoryboardPage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: productDetail, page: () => const ProductDetailPage()),
    GetPage(name: postDetail, page: () => const PostDetailPage()),
  ];
}
