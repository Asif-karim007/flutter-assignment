// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/core/services/api_service.dart';
import 'package:flutter_app/core/services/storage_service.dart';
import 'package:flutter_app/pages/login_page.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  testWidgets('Login page renders expected fields', (WidgetTester tester) async {
    Get.put<AuthController>(AuthController(ApiService(), StorageService()));

    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
