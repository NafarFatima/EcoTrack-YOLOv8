import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';

class AuthErrorWidget extends StatelessWidget {
  final String? errorMessage;

  const AuthErrorWidget({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        errorMessage!,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
