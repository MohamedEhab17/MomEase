import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';

abstract class ChildrenState extends Equatable {
  const ChildrenState();

  @override
  List<Object?> get props => [];
}

class ChildrenInitial extends ChildrenState {}

class ChildrenLoading extends ChildrenState {}

/// Shown while an action (create/update/delete/photo) is in progress
/// but we still want the list visible (e.g. overlay spinner).
class ChildrenActionLoading extends ChildrenState {
  final List<Child> children;
  const ChildrenActionLoading(this.children);

  @override
  List<Object?> get props => [children];
}

class ChildrenLoaded extends ChildrenState {
  final List<Child> children;
  const ChildrenLoaded(this.children);

  @override
  List<Object?> get props => [children];
}

class ChildrenError extends ChildrenState {
  final String message;
  const ChildrenError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChildActionSuccess extends ChildrenState {
  final String message;
  final List<Child> children;
  const ChildActionSuccess({required this.message, required this.children});

  @override
  List<Object?> get props => [message, children];
}

/// Emitted after a child detail load (for the detail screen).
class ChildDetailLoaded extends ChildrenState {
  final Child child;
  const ChildDetailLoaded(this.child);

  @override
  List<Object?> get props => [child];
}
