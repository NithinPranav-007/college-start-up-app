import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/user_model.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl =
      TextEditingController(text: 'student@college.edu');
  final TextEditingController _passwordCtrl =
      TextEditingController(text: 'password123');
  UserRole _selectedRole = UserRole.client;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await ref.read(authControllerProvider.notifier).login(
        _emailCtrl.text.trim(), _passwordCtrl.text.trim(), _selectedRole);
    final AsyncValue<UserModel?> userState = ref.read(authControllerProvider);
    if (mounted && userState.hasValue) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserModel?> authState = ref.watch(authControllerProvider);
    final bool isLoading = authState.isLoading;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C63FF),
              Color(0xFF9D8FF6),
              Color(0xFFFF6584),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.padding * 1.5),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Icon
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school,
                          size: 64,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'CampusXchange',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Campus Marketplace',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Login Card
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: size.width > 600 ? 400 : double.infinity,
                        ),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in with your campus email',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              TextFormField(
                                controller: _emailCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Campus Email',
                                  prefixIcon: Icon(Icons.email_outlined,
                                      color: AppTheme.primaryColor),
                                  hintText: 'you@college.edu',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty)
                                    return 'Email is required';
                                  if (!value.endsWith('@college.edu'))
                                    return 'Use your @college.edu email';
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSizes.gap * 1.5),
                              TextFormField(
                                controller: _passwordCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline,
                                      color: AppTheme.primaryColor),
                                  hintText: '••••••••',
                                ),
                                obscureText: true,
                                validator: (String? value) {
                                  if (value == null || value.length < 6)
                                    return 'Min 6 chars';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'I am a:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: _RoleCard(
                                      icon: Icons.shopping_bag,
                                      label: 'Client',
                                      isSelected:
                                          _selectedRole == UserRole.client,
                                      onTap: () => setState(() =>
                                          _selectedRole = UserRole.client),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _RoleCard(
                                      icon: Icons.store,
                                      label: 'Merchant',
                                      isSelected:
                                          _selectedRole == UserRole.merchant,
                                      onTap: () => setState(() =>
                                          _selectedRole = UserRole.merchant),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              if (authState.hasError)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.red.shade700),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${authState.error}',
                                          style: TextStyle(
                                              color: Colors.red.shade700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              PrimaryButton(
                                label: isLoading ? 'Signing in...' : 'Sign In',
                                isBusy: isLoading,
                                onPressed: _submit,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Forgot Password?'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
