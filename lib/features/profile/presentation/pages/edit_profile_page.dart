import 'package:ecotrack/core/common_widgets/eco_profile_photo.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/profile/presentation/provider/profile_provider.dart';
import 'package:ecotrack/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ecotrack/core/common_widgets/eco_text_field.dart';
import 'package:ecotrack/core/common_widgets/eco_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _titleController;
  File? _selectedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false).userProfile;
    _nameController = TextEditingController(text: profile?.displayName ?? "");
    _emailController = TextEditingController(text: profile?.email ?? "");
    _titleController = TextEditingController(text: profile?.title ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final authProvider = Provider.of<AuthNotifier>(context, listen: false);
      final uid = authProvider.user?.uid;

      if (uid == null) throw Exception("User not logged in");

      if (_selectedImage != null) {
        await profileProvider.updateProfilePhoto(uid, _selectedImage!);
      }

      await profileProvider.updateProfile(
        uid: uid,
        name: _nameController.text,
        title: _titleController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: AppColors.primarySecondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final profile = provider.userProfile;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20.r),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            _selectedImage != null
                                ? Container(
                                    width: 120.r,
                                    height: 120.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.primarySecondary, width: 3.r),
                                      image: DecorationImage(
                                        image: FileImage(_selectedImage!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : EcoProfilePhoto(
                                    photoUrl: profile?.profilePhoto,
                                    size: 120,
                                    borderWith: 3,
                                    borderColor: AppColors.primarySecondary,
                                    iconSize: 60,
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: const BoxDecoration(
                                  color: AppColors.primarySecondary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.camera_alt, color: AppColors.white, size: 20.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    EcoTextField(
                      label: 'FULL NAME',
                      controller: _nameController,
                      hint: 'Enter your full name',
                      style: EcoTextFieldStyle.underlined,
                    ),
                    SizedBox(height: 24.h),
                    EcoTextField(
                      label: 'EMAIL ADDRESS',
                      controller: _emailController,
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      style: EcoTextFieldStyle.underlined,
                    ),
                    SizedBox(height: 24.h),
                    EcoTextField(
                      label: 'TITLE / BIO',
                      controller: _titleController,
                      hint: 'Describe yourself',
                      style: EcoTextFieldStyle.underlined,
                    ),
                    SizedBox(height: 48.h),
                    EcoButton(
                      text: 'Save Changes',
                      onPressed: _isSaving ? null : _saveProfile,
                      isLoading: _isSaving,
                      style: EcoButtonStyle.solid,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}
