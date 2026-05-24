import 'package:equatable/equatable.dart';
import '../../domain/entity/mother_profile.dart';

enum ProfileStatus { initial, loading, loaded, error, updating, uploadingPhoto, deletingPhoto }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final MotherProfile? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    MotherProfile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
