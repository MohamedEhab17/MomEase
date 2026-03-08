import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_state.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/widgets/skin_diagnosis_actions.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/widgets/skin_diagnosis_image_preview.dart';

class SkinDiagnosisPhotoView extends StatelessWidget {
  const SkinDiagnosisPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FeaturesHeader(title: 'Skin Diagnosis'),
      body: BlocConsumer<SkinDiagnosisCubit, SkinDiagnosisState>(
        listener: (context, state) {
          if (state.status == SkinDiagnosisStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
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
