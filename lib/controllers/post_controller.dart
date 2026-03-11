import 'package:get/get.dart';

import '../core/services/api_service.dart';
import '../models/post_model.dart';

class PostController extends GetxController {
  PostController(this._apiService);

  static const int _limit = 10;

  final ApiService _apiService;

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString paginationError = ''.obs;
  final RxBool hasMore = true.obs;

  int _page = 0;

  @override
  void onInit() {
    super.onInit();
    fetchInitialPosts();
  }

  Future<void> fetchInitialPosts() async {
    isLoading.value = true;
    errorMessage.value = '';
    paginationError.value = '';
    hasMore.value = true;
    _page = 0;

    try {
      final data = await _apiService.fetchPosts(limit: _limit, skip: 0);
      posts.assignAll(data);
      hasMore.value = data.length == _limit;
      _page = 1;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      posts.clear();
    } catch (_) {
      errorMessage.value = 'Unable to load posts.';
      posts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMorePosts() async {
    if (isPaginationLoading.value || !hasMore.value || isLoading.value) {
      return;
    }

    isPaginationLoading.value = true;
    paginationError.value = '';

    try {
      final data = await _apiService.fetchPosts(
        limit: _limit,
        skip: _page * _limit,
      );
      posts.addAll(data);
      hasMore.value = data.length == _limit;
      _page++;
    } on ApiException catch (e) {
      paginationError.value = e.message;
    } catch (_) {
      paginationError.value = 'Unable to load more posts.';
    } finally {
      isPaginationLoading.value = false;
    }
  }
}
