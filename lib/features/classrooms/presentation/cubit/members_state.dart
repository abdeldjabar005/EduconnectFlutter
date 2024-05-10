part of 'members_cubit.dart';

abstract class MembersState extends Equatable {
  const MembersState();

  @override
  List<Object> get props => [];
}

class MembersInitial extends MembersState {}

class MembersLoading extends MembersState {}

class MembersLoaded extends MembersState {
  final List<MemberModel> members;

  MembersLoaded(this.members);

  @override
  List<Object> get props => [members];
}

class NoMembers extends MembersState {
  final String message;

  NoMembers(this.message);

  @override
  List<Object> get props => [message];
}

class AssociateStudentSuccess extends MembersState {}

class StudentAlreadyAssociated extends MembersState {}
class MembersError extends MembersState {
  final String message;

  MembersError(this.message);

  @override
  List<Object> get props => [message];
}
class LeftSuccess extends MembersState {}
class Members2Error extends MembersState {
  final String message;

  Members2Error(this.message);

  @override
  List<Object> get props => [message];
}




class RequestsLoaded extends MembersState {
  final List<RequestModel> requests;

  RequestsLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}
class NoRequests extends MembersState {
  final String message;

  NoRequests(this.message);

  @override
  List<Object> get props => [message];
}