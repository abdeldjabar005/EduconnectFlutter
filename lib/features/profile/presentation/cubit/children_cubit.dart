import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';
import 'package:quotes/features/profile/domain/usecases/add_child.dart';
import 'package:quotes/features/profile/domain/usecases/get_children.dart';
import 'package:quotes/features/profile/domain/usecases/remove_child.dart';
import 'package:quotes/features/profile/domain/usecases/update_child.dart';

part 'children_state.dart';

class ChildrenCubit extends Cubit<ChildrenState> {
  final GetChildren getChildrenUseCase;
  final AddChildUseCase addChildUseCase;
  final RemoveChild removeChildUseCase;
  final UpdateChildUseCase updateChildUseCase;
  List<ChildModel>? _children = [];

  final childrenCache = ValueNotifier<List<ChildModel>>([]);

  ChildrenCubit(
      {required this.getChildrenUseCase,
      required this.addChildUseCase,
      required this.removeChildUseCase,
      required this.updateChildUseCase})
      : super(ChildrenInitial());

  Future<void> getChildren({bool useCache = true}) async {
    if (useCache && _children != null && _children!.isNotEmpty) {
      emit(ChildrenLoaded(children: _children!));
      return;
    }

    try {
      emit(ChildrenLoading());
      final children = await getChildrenUseCase("ss");
      children.fold(
          (failure) =>
              emit(ChildrenError(message: _mapFailureToMessage(failure))),
          (children) {
        _children = children;
        if (children.isEmpty) {
          List<ChildModel> newList = List.from(childrenCache.value);
          newList.addAll(children);
          childrenCache.value = newList;
          childrenCache.notifyListeners();
          emit(const ChildrenEmpty(message: 'No children found'));
        } else {
          emit(ChildrenLoaded(children: children));
        }
      });
    } catch (e) {
      emit(ChildrenError(message: e.toString()));
    }
  }

  Future<void> addChild(ChildModel child) async {
    try {
      emit(ChildrenLoading());
      final result = await addChildUseCase(child);
      result.fold((failure) {
        emit(ChildrenError(message: _mapFailureToMessage(failure)));
      }, (createdChild) {
        _children!.add(createdChild);
        List<ChildModel> newList = List.from(childrenCache.value);
        newList.add(createdChild);
        childrenCache.value = newList;
        childrenCache.notifyListeners();
        emit(ChildrenLoaded(children: _children!));
      });
    } catch (e) {
      emit(ChildrenError(message: e.toString()));
    }
  }

  Future<void> removeChild(ChildModel child) async {
    try {
      emit(ChildrenLoading());
      final result = await removeChildUseCase(child.id);
      result.fold((failure) {
        emit(ChildrenError(message: _mapFailureToMessage(failure)));
      }, (_) async {
        await getChildren(useCache: false);
      });
    } catch (e) {
      emit(ChildrenError(message: e.toString()));
    }
  }

  Future<void> updateChild(ChildModel child) async {
    try {
      emit(ChildrenLoading());
      final result = await updateChildUseCase(child);
      result.fold((failure) {
        emit(ChildrenError(message: _mapFailureToMessage(failure)));
      }, (_) async {
        await getChildren(useCache: false);
      });
    } catch (e) {
      emit(ChildrenError(message: e.toString()));
    }
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
