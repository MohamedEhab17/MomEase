import 'package:equatable/equatable.dart';

class AddGrowthRecordRequestModel extends Equatable {
  final double weightKg;
  final double heightCm;

  const AddGrowthRecordRequestModel({
    required this.weightKg,
    required this.heightCm,
  });

  Map<String, dynamic> toJson() {
    return {
      'weightKg': weightKg,
      'heightCm': heightCm,
    };
  }

  @override
  List<Object?> get props => [weightKg, heightCm];
}
