import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/home/presentation/pages/main_shell.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_error_widget.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_header.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_switch_row.dart';
import '../provider/auth_provider.dart';
import 'package:ecotrack/core/common_widgets/eco_text_field.dart';
import 'package:ecotrack/core/common_widgets/eco_button.dart';
import 'signup_page.dart';
import 'reset_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
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
                title: 'Welcome Back',
                subtitle: 'Sign in to continue your eco journey',
              ),
              SizedBox(height: 48.h),
              AuthErrorWidget(errorMessage: auth.errorMessage),
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
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResetPassword()),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              EcoButton(
                text: 'Sign In',
                isLoading: auth.isLoading,
                style: EcoButtonStyle.solid,
                backgroundColor: AppColors.primary,
                onPressed: () async {
                  final authNotifier = context.read<AuthNotifier>();
                  await authNotifier.signIn(
                    emailcontroller.text,
                    passwordcontroller.text,
                  );
                  if (authNotifier.errorMessage == null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainShell()),
                    );
                  }
                },
              ),
              SizedBox(height: 24.h),
              AuthSwitchRow(
                question: "Don't have an account? ",
                actionText: 'Sign Up',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
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
