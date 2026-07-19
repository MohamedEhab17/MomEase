import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';

@lazySingleton
class ActiveChildCubit extends Cubit<Child?> {
  ActiveChildCubit() : super(null);

  void setActiveChild(Child child) {
    emit(child);
  }

  void clearActiveChild() {
    emit(null);
  }
}
