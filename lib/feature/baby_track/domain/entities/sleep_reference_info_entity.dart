import 'package:equatable/equatable.dart';

class SleepReferenceInfoEntity extends Equatable {
  final String sleepMinHours;
  final String sleepMaxHours;
  final String sleepMinHoursFormatted;
  final String sleepMaxHoursFormatted;
  final String ageRange;

  const SleepReferenceInfoEntity({
    required this.sleepMinHours,
    required this.sleepMaxHours,
    required this.sleepMinHoursFormatted,
    required this.sleepMaxHoursFormatted,
    required this.ageRange,
  });

  @override
  List<Object?> get props => [
        sleepMinHours,
        sleepMaxHours,
        sleepMinHoursFormatted,
        sleepMaxHoursFormatted,
        ageRange,
      ];
}
