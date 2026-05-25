import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_assets.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128.r,
      height: 128.r,
      decoration: BoxDecoration(
        color: const Color(0xFF0D631B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48.r),
          bottomRight: Radius.circular(48.r),
          topRight: Radius.circular(8.r),
          bottomLeft: Radius.circular(8.r),
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 50.r,
            offset: Offset(0, 25.h),
            spreadRadius: -12.r,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48.r),
          bottomRight: Radius.circular(48.r),
          topRight: Radius.circular(8.r),
          bottomLeft: Radius.circular(8.r),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.r, sigmaY: 12.r),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.leafIcon,
              width: 42.6.r,
              height: 42.6.r,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
