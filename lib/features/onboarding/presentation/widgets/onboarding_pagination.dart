import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';

class OnboardingPagination extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const OnboardingPagination({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: 8.w),
          width: currentIndex == index ? 32.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColors.primarySecondary : const Color(0x80D9D9D9),
            borderRadius: BorderRadius.circular(currentIndex == index ? 4.r : 8.r),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
