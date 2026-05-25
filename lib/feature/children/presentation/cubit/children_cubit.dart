import 'dart:io';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/core/helpers/child_image_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';
import 'package:new_mama/feature/children/domain/usecases/create_child_use_case.dart';
import 'package:new_mama/feature/children/domain/usecases/delete_child_use_case.dart';
import 'package:new_mama/feature/children/domain/usecases/get_children_use_case.dart';
import 'package:new_mama/feature/children/domain/usecases/manage_child_photo_use_case.dart';
import 'package:new_mama/feature/children/domain/usecases/update_child_use_case.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_state.dart';

@lazySingleton
class ChildrenCubit extends SafeCubit<ChildrenState> {
  final GetChildrenUseCase _getChildren;
  final CreateChildUseCase _createChild;
  final UpdateChildUseCase _updateChild;
  final DeleteChildUseCase _deleteChild;
  final UploadChildPhotoUseCase _uploadPhoto;
  final DeleteChildPhotoUseCase _deletePhoto;

  ChildrenCubit(
    this._getChildren,
    this._createChild,
    this._updateChild,
    this._deleteChild,
    this._uploadPhoto,
    this._deletePhoto,
  ) : super(ChildrenInitial());

  List<Child> _currentChildren = [];


  Future<void> loadChildren() async {
    cancelableOperation(
      _getChildren().then((result) {
        result.fold(
          (failure) => emit(ChildrenError(failure.message)),
          (children) {
            _currentChildren = children;
            emit(ChildrenLoaded(children));
          },
        );
      }),
    );
    if (_currentChildren.isEmpty) {
      emit(ChildrenLoading());
    }
  }


  Future<void> createChild(CreateChildParams params) async {
    emit(ChildrenActionLoading(_currentChildren));
    cancelableOperation(
      _createChild(params).then((result) {
        result.fold(
          (failure) => emit(ChildrenError(failure.message)),
          (child) {
            _currentChildren = [..._currentChildren, child];
            emit(ChildActionSuccess(
              message: TK.childrenAddSuccess,
              children: _currentChildren,
            ));
          },
        );
      }),
    );
  }

  Future<void> updateChild(int childId, UpdateChildParams params) async {
    emit(ChildrenActionLoading(_currentChildren));
    cancelableOperation(
      _updateChild(childId, params).then((result) {
        result.fold(
          (failure) => emit(ChildrenError(failure.message)),
          (updated) {
            _currentChildren = _currentChildren
                .map((c) => c.childId == childId ? updated : c)
                .toList();
            emit(ChildActionSuccess(
              message: TK.childrenUpdateSuccess,
              children: _currentChildren,
            ));
          },
        );
      }),
    );
  }

  Future<void> deleteChild(int childId) async {
    emit(ChildrenActionLoading(_currentChildren));
    cancelableOperation(
      _deleteChild(childId).then((result) {
        result.fold(
          (failure) => emit(ChildrenError(failure.message)),
          (message) {
            _currentChildren =
                _currentChildren.where((c) => c.childId != childId).toList();
            emit(ChildActionSuccess(
              message: TK.childrenDeleteSuccess,
              children: _currentChildren,
            ));
          },
        );
      }),
    );
  }

  Future<void> uploadPhoto(int childId, File photo) async {
    emit(ChildrenActionLoading(_currentChildren));
    cancelableOperation(
      _uploadPhoto(childId, photo).then((result) {
        result.fold(
          (failure) => emit(ChildrenError(failure.message)),
          (photoUrl) {
            _currentChildren = _currentChildren.map((c) {
              if (c.childId == childId) {
                return Child(
                  childId: c.childId,
                  fullName: c.fullName,
                  gender: c.gender,
                  birthDate: c.birthDate,
                  ageInMonths: c.ageInMonths,
                  ageInDays: c.ageInDays,
                  deliveryType: c.deliveryType,
                  feedingTypeForBaby: c.feedingTypeForBaby,
                  photoUrl: _resolvePhotoUrl(photoUrl, fallback: c.photoUrl),
                );
              }
              return c;
            }).toList();
            emit(ChildActionSuccess(
              message: TK.childrenPhotoSuccess,
              children: _currentChildren,
            ));
          },
        );
      }),
    );
  }

  Future<void> deletePhoto(int childId) async {
    emit(ChildrenActionLoading(_currentChildren));
    cancelableOperation(
      _deletePhoto(childId).then((result) {
        result.fold(
          (failure) => emit(ChildrenError(failure.message)),
          (message) {
            _currentChildren = _currentChildren.map((c) {
              if (c.childId == childId) {
                return Child(
                  childId: c.childId,
                  fullName: c.fullName,
                  gender: c.gender,
                  birthDate: c.birthDate,
                  ageInMonths: c.ageInMonths,
                  ageInDays: c.ageInDays,
                  deliveryType: c.deliveryType,
                  feedingTypeForBaby: c.feedingTypeForBaby,
                  photoUrl: null,
                );
              }
              return c;
            }).toList();
            emit(ChildActionSuccess(message: TK.childrenPhotoDeleteSuccess, children: _currentChildren));
          },
        );
      }),
    );
  }

  /// Restores the loaded state after a success (UI can call after showing toast).
  void restoreLoaded() {
    emit(ChildrenLoaded(_currentChildren));
  }

  /// Resolves a raw [rawUrl] (from API) into an absolute URL.
  /// Returns [fallback] when [rawUrl] is empty or unresolvable.
  String? _resolvePhotoUrl(String rawUrl, {String? fallback}) {
    final resolved = ChildImageHelper.getChildImageUrl(rawUrl);
    return resolved.isEmpty ? fallback : resolved;
  }
}
