import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/features/profile/presentation/cubit/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(selectedIndex: 0));

  void updateNavigationIndex(int index) {
    emit(NavigationState(selectedIndex: index));
  }
}