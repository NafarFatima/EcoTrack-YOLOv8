import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_error_widget.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_header.dart';
import 'package:ecotrack/features/authentication/presentation/widgets/auth_info_widget.dart';
import 'package:ecotrack/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ecotrack/core/common_widgets/eco_text_field.dart';
import 'package:ecotrack/core/common_widgets/eco_button.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AuthHeader(
                title: 'Forgot your password?',
                subtitle: 'Enter your email and we will send you a reset link.',
              ),
              SizedBox(height: 48.h),
              AuthErrorWidget(errorMessage: auth.errorMessage),
              AuthInfoWidget(infoMessage: auth.infoMessage),
              EcoTextField(
                label: 'Email Address',
                hint: 'Enter your email',
                controller: emailcontroller,
              ),

              SizedBox(height: 40.h),

              EcoButton(
                text: 'Send Reset Link',
                isLoading: auth.isLoading,
                style: EcoButtonStyle.solid,
                backgroundColor: AppColors.primary,
                onPressed: () async {
                  final email = emailcontroller.text.trim();

                  if (email.isEmpty || !email.contains('@')) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Enter a valid email"),
                      ),
                    );
                    return;
                  }

                  await context
                      .read<AuthNotifier>()
                      .sendPasswordReset(email);

                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of (context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "If email exists, reset link sent",
                      ),
                    ),
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
