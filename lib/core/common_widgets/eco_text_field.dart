import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';

enum EcoTextFieldStyle { filledOutlined, underlined, container }

class EcoTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool isTextArea;
  final TextInputType keyboardType;
  final EcoTextFieldStyle style;
  final FocusNode? focusNode;

  const EcoTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.isTextArea = false,
    this.keyboardType = TextInputType.text,
    this.style = EcoTextFieldStyle.filledOutlined,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    if (style == EcoTextFieldStyle.container) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                fontSize: 10.sp,
                letterSpacing: 2.0.w,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            height: isTextArea ? 94.h : 54.h,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: isTextArea ? 16.h : 0),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(isTextArea ? 24.r : 48.r),
              border: Border.all(color: AppColors.cardBorder, width: 1.w),
            ),
            alignment: isTextArea ? Alignment.topLeft : Alignment.centerLeft,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: isTextArea ? 3 : 1,
              obscureText: isPassword,
              keyboardType: keyboardType,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                isCollapsed: !isTextArea,
              ),
            ),
          ),
        ],
      );
    }

    if (style == EcoTextFieldStyle.underlined) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 1.0.w,
              fontFamily: 'Manrope',
            ),
          ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: isPassword,
            maxLines: isTextArea ? 3 : 1,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontFamily: 'Manrope'),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 16.sp, fontWeight: FontWeight.w800),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primarySecondary)),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ],
      );
    }

    // Default: filledOutlined (used in Auth)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLines: isTextArea ? 3 : 1,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 16.sp),
            filled: true,
            fillColor: AppColors.cardBg.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          ),
        ),
      ],
    );
  }
}
