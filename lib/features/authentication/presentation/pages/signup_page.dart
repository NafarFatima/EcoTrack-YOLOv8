import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_error_widget.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_header.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_switch_row.dart';
import '../provider/auth_provider.dart';
import 'package:ecotrack/core/common_widgets/eco_text_field.dart';
import 'package:ecotrack/core/common_widgets/eco_button.dart';
import 'login_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AuthHeader(
                title: 'Create Account',
                subtitle: 'Join our community for a greener future',
              ),
              SizedBox(height: 48.h),
              AuthErrorWidget(errorMessage: auth.errorMessage),
              EcoTextField(
                label: 'Full Name',
                hint: 'Enter your full name',
                controller: namecontroller,
              ),
              SizedBox(height: 20.h),
              EcoTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: emailcontroller,
              ),
              SizedBox(height: 20.h),
              EcoTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: passwordcontroller,
                isPassword: true,
              ),
              SizedBox(height: 20.h),
              EcoTextField(
                label: 'Confirm Password',
                hint: 'Confirm your password',
                controller: confirmpasswordcontroller,
                isPassword: true,
              ),
              SizedBox(height: 40.h),
              EcoButton(
                text: 'Sign Up',
                isLoading: auth.isLoading,
                style: EcoButtonStyle.solid,
                backgroundColor: AppColors.primary,
                onPressed: () async {
                  if (passwordcontroller.text != confirmpasswordcontroller.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match!')),
                    );
                    return;
                  }

                  final authNotifier = context.read<AuthNotifier>();
                  await authNotifier.signUp(
                    emailcontroller.text,
                    passwordcontroller.text,
                    namecontroller.text,
                  );
                  if (authNotifier.errorMessage == null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account created successfully! Please login.')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
              ),
              SizedBox(height: 24.h),
              AuthSwitchRow(
                question: "Already have an account? ",
                actionText: 'Sign In',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
