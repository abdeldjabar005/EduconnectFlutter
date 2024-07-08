import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/classrooms/data/models/member_model.dart';
import 'package:educonnect/features/classrooms/data/models/request_model.dart';
import 'package:educonnect/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:educonnect/features/classrooms/domain/usecases/get_memebrs.dart';

part 'members_state.dart';

class MembersCubit extends Cubit<MembersState> {
  final ClassroomRepository classroomRepository;
  final GetMembersUseCase getMembersUseCase;

  final membersCache = ValueNotifier<Map<int, List<MemberModel>>>({});
  final requestmembers = ValueNotifier<Map<int, List<RequestModel>>>({});

  MembersCubit(
      {required this.classroomRepository, required this.getMembersUseCase})
      : super(MembersInitial());

  Future<void> getMembers(int id) async {
    emit(MembersLoading());

    if (membersCache.value.containsKey(id)) {
      final members = membersCache.value[id];
      if (members != null && members.isNotEmpty) {
        emit(MembersLoaded(members));
      } else {
        emit(NoMembers("No comments found"));
      }
    } else {
      emit(MembersLoading());
      final result =
          await getMembersUseCase.call(Params4(id: id, type: "school"));
      result.fold(
        (failure) {
          emit(MembersError(_mapFailureToMessage(failure)));
        },
        (members) {
          membersCache.value[id] = members;
          if (members.isNotEmpty) {
            emit(MembersLoaded(members));
          } else {
            emit(NoMembers("No members"));
          }
        },
      );
    }
  }

  Future<void> getMembers2(int id) async {
    if (membersCache.value.containsKey(id)) {
      final members = membersCache.value[id];
      if (members != null && members.isNotEmpty) {
        emit(MembersLoaded(members));
      } else {
        emit(NoMembers("No comments found"));
      }
    } else {
      emit(MembersLoading());
      final result =
          await getMembersUseCase.call(Params4(id: id, type: "class"));
      result.fold(
        (failure) {
          emit(MembersError(_mapFailureToMessage(failure)));
        },
        (members) {
          membersCache.value[id] = members;
          if (members.isNotEmpty) {
            emit(MembersLoaded(members));
          } else {
            emit(NoMembers("No members"));
          }
        },
      );
    }
  }

  Future<void> removeMember(int id, int id2, String type) async {
    emit(MembersLoading());
    final result = await classroomRepository.removeMember(id, id2, type);
    result.fold(
      (failure) {
        emit(MembersError(_mapFailureToMessage(failure)));
      },
      (_) {
        List<MemberModel> newList = List.from(membersCache.value.values);
        newList.removeWhere((member) => member.id == id);
        membersCache.value[id] = newList;
        membersCache.notifyListeners();

        if (membersCache.value[id] != null) {
          emit(MembersLoaded(membersCache.value[id]!));
        } else {
          emit(NoMembers("No members"));
        }
      },
    );
  }

  Future<void> getRequests(int id, String type) async {
    emit(MembersLoading());
    final result = await classroomRepository.getRequests(id, type);
    result.fold(
      (failure) {
        emit(MembersError(_mapFailureToMessage(failure)));
      },
      (requests) {
        if (requests.isNotEmpty) {
          requestmembers.value[id] = requests;

          emit(RequestsLoaded(requests));
        } else {
          emit(NoRequests("No requests"));
        }
      },
    );
  }

  Future<void> acceptMember(int id, int schoolId, String type) async {
    emit(MembersLoading());

    final result = await classroomRepository.accept(id, type);
    result.fold(
      (failure) {
        emit(MembersError(_mapFailureToMessage(failure)));
      },
      (member) {
        final members = membersCache.value[schoolId];
        final requests = requestmembers.value[schoolId];

        if (members != null) {
          members.add(member);
          membersCache.value[schoolId] = members;

          requests!.removeWhere((member) => member.id == id);
          requestmembers.value[schoolId] = requests;

          emit(MembersLoaded(members));
        }
      },
    );
  }

  Future<void> refuseMember(int id, int schoolId, String type) async {
    emit(MembersLoading());
    final result = await classroomRepository.refuse(id, type);
    result.fold(
      (failure) {
        emit(MembersError(_mapFailureToMessage(failure)));
      },
      (_) {
        final requests = requestmembers.value[schoolId];
        final members = membersCache.value[schoolId];
        members!.removeWhere((member) => member.id == id);

        requests!.removeWhere((member) => member.id == id);
        requestmembers.value[schoolId] = requests;
        emit(MembersLoaded(members));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected error';
    }
  }
}
