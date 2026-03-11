import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  final AuthController _authController = Get.find<AuthController>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _authController.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0B1220),
                    const Color(0xFF111C33),
                    const Color(0xFF162746),
                  ]
                : [
                    const Color(0xFFEAF2FF),
                    const Color(0xFFF4F8FF),
                    const Color(0xFFE2EEFF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  elevation: isDark ? 2 : 1,
                  color: isDark ? null : Colors.white.withOpacity(0.96),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: colorScheme.primary.withOpacity(0.12),
                            child: Icon(Icons.lock_outline, color: colorScheme.primary),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign in to continue',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _usernameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.key_outlined),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Obx(() {
                            final error = _authController.errorMessage.value;
                            if (error.isEmpty) return const SizedBox.shrink();

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                error,
                                style: TextStyle(color: colorScheme.onErrorContainer),
                              ),
                            );
                          }),
                          SizedBox(
                            height: 48,
                            child: Obx(() {
                              final isLoading = _authController.isLoading.value;

                              return ElevatedButton.icon(
                                onPressed: isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F5FCC),
                                  foregroundColor: Colors.white,
                                ),
                                icon: isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.login),
                                label: Text(isLoading ? 'Signing In...' : 'Login'),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
