import 'package:ecotrack/features/onboarding/domain/entity/onboarding_content.dart';

class OnboardingModel extends OnboardingContent {
  OnboardingModel({
    required super.title,
    required super.titleHighlighted,
    required super.description,
    required super.image,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      title: json['title'],
      titleHighlighted: json['titleHighlighted'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'titleHighlighted': titleHighlighted,
      'description': description,
      'image': image,
    };
  }
}
