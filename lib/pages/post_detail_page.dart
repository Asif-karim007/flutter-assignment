import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/post_model.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final post = Get.arguments as PostModel?;

    if (post == null) {
      return const Scaffold(
        body: Center(child: Text('Post not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(post.body),
        ],
      ),
    );
  }
}
