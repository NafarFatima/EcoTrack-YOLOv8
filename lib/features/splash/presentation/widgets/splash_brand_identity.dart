import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';

class SplashBrandIdentity extends StatelessWidget {
  const SplashBrandIdentity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Heading 1 - EcoTrack with Box
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.w),
          ),
          child: Text(
            'EcoTrack',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              fontSize: 48.sp,
              height: 1.0,
              letterSpacing: -2.4.w,
              color: const Color(0xFF0D631B),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Subtitle
        Text(
          'Recycle for a Greener Tomorrow',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
            height: 1.55,
            letterSpacing: -0.45.w,
            color: const Color(0xFF335F3A).withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
