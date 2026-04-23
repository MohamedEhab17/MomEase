import 'package:equatable/equatable.dart';

class Baby extends Equatable {
  final String name;
  final String gender;
  final String deliveryType;
  final String feedingType;
  final String dateOfBirth;

  const Baby({
    required this.name,
    required this.gender,
    required this.deliveryType,
    required this.feedingType,
    required this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
    name,
    gender,
    deliveryType,
    feedingType,
    dateOfBirth,
  ];
}
