import 'package:edutest/core/themes/app_colors.dart';
import 'package:edutest/features/auth/presentation/pages/signin_page.dart';
import 'package:edutest/shared/widgets/reusable_text_field.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // HEADER
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create an account to get started!',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 32),

              // SOCIAL BUTTONS
              Row(
                children: [
                  _socialButton('Facebook', 'assets/images/logo_facebook.png'),
                  const SizedBox(width: 16),
                  _socialButton('Google', 'assets/images/logo_google.png'),
                ],
              ),

              const SizedBox(height: 24),
              _orDivider(),
              const SizedBox(height: 24),

              // NAME
              ReusableTextField(controller: _nameController, hint: 'Name'),

              const SizedBox(height: 18),

              // EMAIL / PHONE
              ReusableTextField(
                controller: _emailController,
                hint: 'Email/Phone Number',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              // PASSWORD
              ReusableTextField(
                controller: _passwordController,
                hint: 'Password',
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _obscure = !_obscure);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // TERMS & PRIVACY
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agree,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() => _agree = value ?? false);
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: AppColors.textSecondary),
                        children: const [
                          TextSpan(text: "I’m agree to The "),
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(color: AppColors.primary),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // CREATE ACCOUNT BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _agree ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // SIGN IN TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do you have account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SigninPage()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET BANTUAN

  Widget _socialButton(String label, String assetPath) {
    return Expanded(
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: 22),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _orDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
      ],
    );
  }
}
