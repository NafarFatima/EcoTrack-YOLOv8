import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';

class AuthInfoWidget extends StatelessWidget {
  final String? infoMessage;

  const AuthInfoWidget({super.key, this.infoMessage});

  @override
  Widget build(BuildContext context) {
    if (infoMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        infoMessage!,
        style: const TextStyle(color: Colors.green),
        textAlign: TextAlign.center,
      ),
    );
  }
}
