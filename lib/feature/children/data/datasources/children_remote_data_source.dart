import 'dart:io';

import 'package:new_mama/feature/children/data/models/child_model.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

abstract class ChildrenRemoteDataSource {
  Future<List<ChildModel>> getChildren();
  Future<ChildModel> getChild(int childId);
  Future<ChildModel> createChild(CreateChildParams params);
  Future<ChildModel> updateChild(int childId, UpdateChildParams params);
  Future<String> deleteChild(int childId);
  Future<String> uploadPhoto(int childId, File photo);
  Future<String> deletePhoto(int childId);
}
