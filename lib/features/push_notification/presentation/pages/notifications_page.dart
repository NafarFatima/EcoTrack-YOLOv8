import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/push_notification/presentation/provider/notification_provider.dart';
import 'package:ecotrack/features/push_notification/presentation/widgets/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  fontFamily: 'Manrope',
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(24.w),
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              final notification = provider.notifications[index];
              return NotificationItem(
                notification: notification,
                onTap: () {
                  if (notification.isNew) {
                    provider.markAsRead(notification.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
