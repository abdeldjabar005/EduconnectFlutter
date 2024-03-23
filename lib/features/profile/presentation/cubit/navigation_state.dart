import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int selectedIndex;

  NavigationState({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

