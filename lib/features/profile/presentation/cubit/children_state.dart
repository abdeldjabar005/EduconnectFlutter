part of 'children_cubit.dart';

 class ChildrenState extends Equatable {
  const ChildrenState();

  @override
  List<Object> get props => [];
}

 class ChildrenInitial extends ChildrenState {}

  class ChildrenLoading extends ChildrenState {}

  class ChildrenLoaded extends ChildrenState {
  final List<ChildModel> children;
  
  const ChildrenLoaded({required this.children});

  @override
  List<Object> get props => [children];

}

class ChildrenEmpty extends ChildrenState {

  final String message;
  const ChildrenEmpty({required this.message});

  @override
  List<Object> get props => [message];

}

class ChildAdded extends ChildrenState {
  final ChildModel child;
  const ChildAdded({required this.child});
  @override
  List<Object> get props => [child];
}
  
    class ChildrenError extends ChildrenState {
    final String message;
    
    const ChildrenError({required this.message});
  
    @override
    List<Object> get props => [message];
  }