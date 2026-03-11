import 'package:get/get.dart';

import '../core/services/api_service.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  ProductController(this._apiService);

  static const int _limit = 10;

  final ApiService _apiService;

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString paginationError = ''.obs;
  final RxBool hasMore = true.obs;

  int _page = 0;

  @override
  void onInit() {
    super.onInit();
    fetchInitialProducts();
  }

  Future<void> fetchInitialProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    paginationError.value = '';
    hasMore.value = true;
    _page = 0;

    try {
      final data = await _apiService.fetchProducts(limit: _limit, skip: 0);
      products.assignAll(data);
      hasMore.value = data.length == _limit;
      _page = 1;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      products.clear();
    } catch (_) {
      errorMessage.value = 'Unable to load products.';
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreProducts() async {
    if (isPaginationLoading.value || !hasMore.value || isLoading.value) {
      return;
    }

    isPaginationLoading.value = true;
    paginationError.value = '';

    try {
      final data = await _apiService.fetchProducts(
        limit: _limit,
        skip: _page * _limit,
      );
      products.addAll(data);
      hasMore.value = data.length == _limit;
      _page++;
    } on ApiException catch (e) {
      paginationError.value = e.message;
    } catch (_) {
      paginationError.value = 'Unable to load more products.';
    } finally {
      isPaginationLoading.value = false;
    }
  }
}
