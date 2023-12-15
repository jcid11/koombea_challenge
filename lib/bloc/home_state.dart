import 'package:equatable/equatable.dart';

import '../models/user_model.dart';


enum AddUserStatus { initial, loading, loaded, failed }

enum DeleteUserStatus { initial, loading, success, failed }

class HomeState extends Equatable {
  final List<UserModel>? userList;
  final AddUserStatus addUserStatus;
  final DeleteUserStatus deleteUserStatus;

  const HomeState(
      {
        this.userList,
      this.addUserStatus = AddUserStatus.initial,
      this.deleteUserStatus = DeleteUserStatus.initial});

  @override
  List<Object?> get props =>
      [  addUserStatus, deleteUserStatus];

  HomeState copyWith({
          DeleteUserStatus? deleteUserStatus,
          // List<UserModel>? userList,
          AddUserStatus? addUserStatus}) =>
      HomeState(
          addUserStatus: addUserStatus ?? this.addUserStatus,
          deleteUserStatus: deleteUserStatus ?? this.deleteUserStatus,
          // userList: userList??this.userList
      );
}

class GetUserListLoading extends HomeState{}

class GetUserListSuccess extends HomeState{
  const GetUserListSuccess(List<UserModel> userList):super(userList: userList);
}
class GetUserListFailed extends HomeState{}

