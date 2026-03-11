import 'package:get/get.dart';

import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this._apiService, this._storageService);

  final ApiService _apiService;
  final StorageService _storageService;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxnString token = RxnString();

  bool get isLoggedIn => token.value != null && token.value!.isNotEmpty;

  Future<void> restoreSession() async {
    final savedToken = _storageService.getToken();
    final savedUser = _storageService.getUser();

    if (savedToken != null && savedUser != null) {
      token.value = savedToken;
      currentUser.value = savedUser;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    errorMessage.value = '';
    isLoading.value = true;

    try {
      final user = await _apiService.login(username: username, password: password);

      await _storageService.saveUser(user);
      currentUser.value = user;
      token.value = user.token;

      Get.offAllNamed(AppRoutes.home);
      return true;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (_) {
      errorMessage.value = 'Login failed. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearSession();
    currentUser.value = null;
    token.value = null;
    errorMessage.value = '';
    Get.offAllNamed(AppRoutes.login);
  }
}
