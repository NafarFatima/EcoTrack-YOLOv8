import 'package:flutter/material.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';

enum EcoButtonStyle { gradient, solid, outlined }

class EcoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EcoButtonStyle style;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final Widget? icon;

  const EcoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.style = EcoButtonStyle.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    final effectiveHeight = height ?? 64.h;

    if (style == EcoButtonStyle.gradient) {
      return Container(
        width: width ?? double.infinity,
        height: effectiveHeight,
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment(1.0, -0.36),
                  end: Alignment(-1.0, 0.36),
                ),
          color: isDisabled ? AppColors.border : null,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 10.r,
                    offset: Offset(0, 8.h),
                    spreadRadius: -6.r,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 25.r,
                    offset: Offset(0, 20.h),
                    spreadRadius: -5.r,
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16.r),
            child: Center(
              child: _buildContent(),
            ),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primarySecondary,
        foregroundColor: foregroundColor ?? AppColors.white,
        minimumSize: Size(width ?? double.infinity, effectiveHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
        elevation: 0,
      ),
      child: _buildContent(defaultTextColor: foregroundColor ?? AppColors.white),
    );
  }

  Widget _buildContent({Color defaultTextColor = Colors.white}) {
    if (isLoading) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    final textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w800,
        fontSize: 16.sp,
        color: defaultTextColor,
      ),
    );

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textWidget,
          SizedBox(width: 8.w),
          icon!,
        ],
      );
    }

    return textWidget;
  }
}
