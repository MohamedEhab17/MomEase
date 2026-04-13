import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/onboarding/data/onboarding_model.dart';

List<OnBoardingModel> dataOnboarding() {
  return [
    OnBoardingModel(
      imgPath: 'assets/images/onboarding1.png',
      title: TK.onboardingScreen1Title,
      description: TK.onboardingScreen1Desc,
    ),
    OnBoardingModel(
      imgPath: 'assets/images/onboarding2.png',
      title: TK.onboardingScreen2Title,
      description: TK.onboardingScreen2Desc,
    ),
    OnBoardingModel(
      imgPath: 'assets/images/onboarding3.png',
      title: TK.onboardingScreen3Title,
      description: TK.onboardingScreen3Desc,
    ),
    OnBoardingModel(
      imgPath: 'assets/images/onboarding4.png',
      title: TK.onboardingScreen4Title,
      description: TK.onboardingScreen4Desc,
    ),
  ];
}