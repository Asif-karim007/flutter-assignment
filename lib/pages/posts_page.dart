import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/post_controller.dart';
import '../models/post_model.dart';
import '../routes/app_routes.dart';
import '../widgets/error_state_widget.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage>
    with AutomaticKeepAliveClientMixin<PostsPage> {
  final PostController _controller = Get.find<PostController>();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      _controller.fetchMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return ErrorStateWidget(
            message: _controller.errorMessage.value,
            onRetry: _controller.fetchInitialPosts,
          );
        }

        if (_controller.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No posts found.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _controller.fetchInitialPosts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final itemCount =
            _controller.posts.length + (_controller.isPaginationLoading.value ? 1 : 0);

        return RefreshIndicator(
          onRefresh: _controller.fetchInitialPosts,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index >= _controller.posts.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final PostModel post = _controller.posts[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ListTile(
                  onTap: () => Get.toNamed(AppRoutes.postDetail, arguments: post),
                  title: Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      post.preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final paginationError = _controller.paginationError.value;
        if (paginationError.isEmpty) return const SizedBox.shrink();

        return SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.errorContainer,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    paginationError,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: _controller.fetchMorePosts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
