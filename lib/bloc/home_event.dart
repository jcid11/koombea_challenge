import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserListEvent extends HomeEvent {}

class AddUserToListEvent extends HomeEvent {
  final String name;
  final String lastName;
  final String userName;

  AddUserToListEvent(
      {required this.name, required this.lastName, required this.userName});
}

class DeleteUserEvent extends HomeEvent{
final int userID;

  DeleteUserEvent({required this.userID});

}
