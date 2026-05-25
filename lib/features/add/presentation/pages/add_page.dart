import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/core/constant/app_assets.dart';
import 'package:ecotrack/features/profile/presentation/provider/profile_provider.dart';
import 'package:ecotrack/features/home/presentation/provider/waste_provider.dart';
import 'package:ecotrack/features/home/presentation/provider/mission_provider.dart';
import 'package:ecotrack/features/history/presentation/provider/history_provider.dart';
import 'package:ecotrack/features/add/presentation/provider/add_provider.dart';
import 'package:ecotrack/core/common_widgets/eco_app_bar.dart';
import 'package:ecotrack/core/common_widgets/eco_text_field.dart';
import 'package:ecotrack/core/common_widgets/eco_button.dart';
import '../widgets/dashed_rect_painter.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int _selectedCategoryIndex = 0; // Plastic
  File? _selectedImage;
  bool _isUploading = false;
  bool _showSuccessToast = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  final FocusNode _nameFocusNode = FocusNode();

  bool _isDetecting = false;
  String? _detectionMessage;

  void _resetForm() {
    setState(() {
      _selectedImage = null;
      _selectedCategoryIndex = 0;
      _detectionMessage = null;
      _isDetecting = false;
      _nameController.clear();
      _locationController.clear();
      _notesController.clear();
    });
  }

  Future<void> _pickImage(AddProvider addProvider, {bool useCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: useCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 100, // Maximizing quality for the AI
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (image != null) {
      final file = File(image.path);
      setState(() {
        _selectedImage = file;
        _isDetecting = true;
        _detectionMessage = null;
      });

      try {
        final result = await addProvider.detectCategory(file);
        
        if (result != null && result['index'] != null) {
          final int index = result['index'];
          final double confidence = (result['confidence'] ?? 0.0) * 100;
          
          setState(() {
            _selectedCategoryIndex = index;
            final String rawLabel = result['label'] ?? 'unknown';
            _detectionMessage = "AI: $rawLabel (idx: $index, ${confidence.toStringAsFixed(0)}%)";
            
            if (_nameController.text.isEmpty) {
               _nameController.text = "${addProvider.categories[index].title} Item";
            }
          });
          
          Future.delayed(const Duration(seconds: 7), () {
            if (mounted) setState(() => _detectionMessage = null);
          });
        } else if (addProvider.categories.isEmpty) {
          setState(() {
            _detectionMessage = "Categories still loading. Please select manually.";
          });
          // Try to refresh categories in background
          addProvider.refreshCategories();
        } else if (result != null && result['lowConfidence'] == true) {
          final String label = result['label'] ?? 'item';
          setState(() {
            _detectionMessage = "AI is unsure (saw '$label'). Please select manually.";
          });
        } else if (result != null) {
          final String label = result['label'] ?? 'unknown';
          setState(() {
            _detectionMessage = "AI found '$label', but no category match. Select manually.";
          });
        } else {
          setState(() {
            _detectionMessage = "AI could not identify the item. Please select manually.";
          });
        }
      } catch (e) {
        debugPrint("Detection error: $e");
        setState(() => _detectionMessage = "AI Error. Please select manually.");
      } finally {
        setState(() {
          _isDetecting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<WasteProvider, ProfileProvider, AddProvider, MissionProvider>(
      builder: (context, wasteProvider, profileProvider, addProvider, missionProvider, _) {
        // Auto-open Gallery/Camera if coming from Home "Add Item"
        if (wasteProvider.shouldOpenGallery || wasteProvider.shouldOpenCamera) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              if (wasteProvider.shouldOpenGallery) {
                wasteProvider.consumeOpenGallery();
                _pickImage(addProvider, useCamera: false);
              } else if (wasteProvider.shouldOpenCamera) {
                wasteProvider.consumeOpenCamera();
                _pickImage(addProvider, useCamera: true);
              }
            }
          });
        }

        // Auto-focus Item Name if coming from Home "Log Habit"
        if (wasteProvider.shouldFocusName) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && wasteProvider.shouldFocusName) {
              wasteProvider.consumeFocusName();
              _nameFocusNode.requestFocus();
            }
          });
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 130.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeroSection(),
                          SizedBox(height: 22.h),
                          _buildCategorySection(addProvider),
                          SizedBox(height: 20.h),
                          if (_isDetecting)
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: const CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        "Analyzing image for category...",
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (_detectionMessage != null)
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: _detectionMessage!.contains("Smart AI") 
                                      ? AppColors.primary.withValues(alpha: 0.15)
                                      : Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: _detectionMessage!.contains("Smart AI") 
                                        ? AppColors.primary.withValues(alpha: 0.4)
                                        : Colors.orange.withValues(alpha: 0.3)
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _detectionMessage!.contains("Smart AI") ? Icons.auto_awesome : Icons.info_outline, 
                                      color: _detectionMessage!.contains("Smart AI") ? AppColors.primary : Colors.orange, 
                                      size: 20
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        _detectionMessage!,
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: _detectionMessage!.contains("Smart AI") ? AppColors.primary : Colors.orange.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          _buildUploadAndDetailsSection(addProvider, wasteProvider, missionProvider),
                          SizedBox(height: 24.h),
                          if (_showSuccessToast) _buildSuccessToast(addProvider),
                          SizedBox(height: 120.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: EcoAppBar(
                  userProfile: profileProvider.userProfile,
                  onProfileTap: () => wasteProvider.setTabIndex(4),
                ),
              ),
              if (_isUploading)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Log New Item',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: 30.sp,
                  height: 1.2,
                  letterSpacing: -0.75.w,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: _resetForm,
                icon: Icon(Icons.refresh, color: AppColors.primary, size: 28.r),
                tooltip: 'Clear form and start over',
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'Select a category and help us track your positive environmental impact today.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
              height: 1.625,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(AddProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppAssets.wasteIcon,
              width: 15.83.w,
              height: 16.67.h,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Waste Category',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.isLoading && provider.categories.isEmpty)
          _buildCategoryShimmer()
        else if (provider.categories.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                const Text(
                  'No categories available. Please check your connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () => provider.refreshCategories(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 169 / 118,
            ),
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              return _buildCategoryButton(
                index,
                category.title.toUpperCase(),
                category.iconPath,
              );
            },
          ),
      ],
    );
  }

  Widget _buildCategoryShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 169 / 118,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
        );
      },
    );
  }

  Widget _buildCategoryButton(int index, String label, String iconPath) {
    bool isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected ? Border.all(color: AppColors.primary, width: 2.w) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                shape: BoxShape.circle,
                boxShadow:  [
                  BoxShadow(
                    color: AppColors.cardBorder,
                    blurRadius: 2.r,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 20.w,
                  height: 20.h,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
                height: 1.33,
                letterSpacing: 0.6.w,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadAndDetailsSection(
      AddProvider provider, WasteProvider wasteProvider, MissionProvider missionProvider) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(provider),
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20.r),
              image: _selectedImage != null
                  ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _selectedImage != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_rounded, color: Colors.white, size: 48.r),
                          SizedBox(height: 8.h),
                          Text(
                            "Tap to replace image",
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 14.sp, 
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Manrope'
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : CustomPaint(
                    painter: DashedRectPainter(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      strokeWidth: 2.w,
                      gap: 6.w,
                      dash: 8.w,
                      radius: 20.r,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 56.r,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Add Item Image',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w800,
                              fontSize: 18.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'TAP TO IDENTIFY AUTOMATICALLY',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w800,
                              fontSize: 10.sp,
                              letterSpacing: 0.8.w,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 24.h),
        EcoTextField(
          label: 'ITEM NAME',
          hint: 'e.g., Green Glass Bottle',
          controller: _nameController,
          focusNode: _nameFocusNode,
          style: EcoTextFieldStyle.container,
        ),
        SizedBox(height: 20.h),
        EcoTextField(
          label: 'LOCATION',
          hint: 'e.g., Downtown Recycling Center',
          controller: _locationController,
          style: EcoTextFieldStyle.container,
        ),
        SizedBox(height: 20.h),
        EcoTextField(
          label: 'NOTES (OPTIONAL)',
          hint: 'Any specific details about the item',
          controller: _notesController,
          isTextArea: true,
          style: EcoTextFieldStyle.container,
        ),
        SizedBox(height: 32.h),
        EcoButton(
          text: _isUploading ? 'Logging...' : 'Submit Item',
          isLoading: _isUploading,
          onPressed: (provider.categories.isEmpty || _isUploading)
              ? null
              : () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter an item name.')),
                    );
                    return;
                  }
                  if (_locationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a location.')),
                    );
                    return;
                  }
                  setState(() => _isUploading = true);
                  try {
                    if (provider.categories.isEmpty) {
                        throw Exception("Categories not loaded yet.");
                    }
                    if (_selectedCategoryIndex >= provider.categories.length) {
                        _selectedCategoryIndex = 0;
                    }
                    final category = provider.categories[_selectedCategoryIndex];
                    await provider.logWaste(
                      category: category,
                      quantity: 1.0,
                      location: _locationController.text,
                      itemName: _nameController.text.isEmpty ? null : _nameController.text,
                      notes: _notesController.text.isEmpty ? null : _notesController.text,
                      imageFile: _selectedImage,
                      availableMissions: missionProvider.missions,
                    );
                    wasteProvider.refreshLogs();
                    if (!mounted) return;
                    context.read<HistoryProvider>().fetchHistory();
                    _nameController.clear();
                    _locationController.clear();
                    _notesController.clear();
                    setState(() {
                      _selectedImage = null;
                      _showSuccessToast = true;
                    });
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted) {
                        setState(() => _showSuccessToast = false);
                      }
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error logging item: $e')),
                    );
                  } finally {
                    setState(() => _isUploading = false);
                  }
                },
        ),
      ],
    );
  }

  Widget _buildSuccessToast(AddProvider addProvider) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 80.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          left: BorderSide(color: AppColors.primary, width: 8.w),
        ),
        boxShadow:  [
          BoxShadow(
            color: AppColors.cardBorder,
            blurRadius: 6.r,
            offset: Offset(0, 4.h),
            spreadRadius: -4.r,
          ),
          BoxShadow(
            color: AppColors.cardBorder,
            blurRadius: 15.r,
            offset: Offset(0, 10.h),
            spreadRadius: -3.r,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.tickIcon,
                      width: 16.67.w,
                      height: 16.67.h,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Item Logged!',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'REWARDS EARNED',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          letterSpacing: 0.5.w,
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${addProvider.lastPointsEarned}pts',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
