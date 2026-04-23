import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_state.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/widgets/skin_diagnosis_actions.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/widgets/skin_diagnosis_image_preview.dart';
import 'package:new_mama/feature/children/presentation/widgets/premium_child_selector.dart';

class SkinDiagnosisPhotoView extends StatelessWidget {
  const SkinDiagnosisPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: FeaturesHeader(title: context.trContext(TK.skinAppBarTitle)),
      body: BlocConsumer<SkinDiagnosisCubit, SkinDiagnosisState>(
        listener: (context, state) {
          if (state.status == SkinDiagnosisStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? context.trContext(TK.skinError)),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
            child: Column(
              children: [
                const PremiumChildSelector(),
                20.h.height,
                SkinDiagnosisImagePreview(state: state),
                68.height,
                SkinDiagnosisActions(state: state),
                32.h.height,
              ],
            ),
          );
        },
      ),
    );
  }
}
