//! data onboarding
import 'package:new_mama/feature/onboarding/data/onboarding_model.dart';

List<OnBoardingModel> dataOnboarding() {
  return [
    OnBoardingModel(
      imgPath: 'assets/images/onboarding1.png',
      title: 'You\’re not alone anymore',
      description:
          'Get emotional support and expert guidance throughout your postpartum journey.',
    ),
    OnBoardingModel(
      imgPath: 'assets/images/onboarding2.png',
      title: 'Breastfeeding support made simple',
      description: 'Access trusted tips, answers, and step-by-step guides.',
    ),
    OnBoardingModel(
      imgPath: 'assets/images/onboarding3.png',
      title: 'Everything you need, in one place',
      description:
          'Read expert articles about health, sleep, nutrition, and baby care.',
    ),
    OnBoardingModel(
      imgPath: 'assets/images/onboarding4.png',
      title: 'Your Support Starts Here',
      description:
          'Helpful tools, trusted information, and a caring community—right at your fingertips',
    ),
  ];
}