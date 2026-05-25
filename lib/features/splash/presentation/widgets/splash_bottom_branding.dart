import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_assets.dart';

class SplashBottomBranding extends StatelessWidget {
  const SplashBottomBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Padding(
        padding: EdgeInsets.only(bottom: 50.h, left: 48.w, right: 48.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.tickIcon,
              width: 12.8.r,
              height: 12.25.r,
              colorFilter: const ColorFilter.mode(Color(0xFF7A9A7A), BlendMode.srcIn),
            ),
            SizedBox(width: 8.w),
            Text(
              'ECO-CERTIFIED PLATFORM',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 10.sp,
                height: 1.5,
                letterSpacing: 2.w,
                color: const Color(0xFF7A9A7A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
