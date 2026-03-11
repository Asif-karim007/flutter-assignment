import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_bootstrap.dart';

class StoryboardPage extends StatefulWidget {
  const StoryboardPage({super.key});

  @override
  State<StoryboardPage> createState() => _StoryboardPageState();
}

class _StoryboardPageState extends State<StoryboardPage> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final nextRoute = await AppBootstrap.init();
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      Get.offAllNamed(nextRoute);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Startup failed. Please retry.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/t_logo.jpg',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              if (_error == null)
                const CircularProgressIndicator(color: Colors.white)
              else ...[
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: _initialize,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
