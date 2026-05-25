import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/extention/size_extention.dart';

class EcoProfilePhoto extends StatelessWidget {
  final String? photoUrl;
  final double size;
  final double? borderWith;
  final Color? borderColor;
  final IconData fallbackIcon;
  final double? iconSize;

  const EcoProfilePhoto({
    super.key,
    required this.photoUrl,
    this.size = 40,
    this.borderWith,
    this.borderColor,
    this.fallbackIcon = Icons.person,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    bool hasError = false;

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      if (photoUrl!.startsWith('http')) {
        imageProvider = NetworkImage(photoUrl!);
      } else {
        try {
          imageProvider = MemoryImage(base64Decode(photoUrl!));
        } catch (e) {
          hasError = true;
        }
      }
    }

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderWith != null
            ? Border.all(
                color: borderColor ?? AppColors.primary.withValues(alpha: 0.2),
                width: borderWith!.w,
              )
            : null,
        color: (imageProvider == null || hasError) ? AppColors.cardBg : null,
        image: (imageProvider != null && !hasError)
            ? DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: (imageProvider == null || hasError)
          ? Icon(
              fallbackIcon,
              size: iconSize ?? (size * 0.6).r,
              color: AppColors.primary,
            )
          : null,
    );
  }
}
