import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

class UserState extends Equatable {
  final List<UserModel>? userList;

  const UserState({this.userList=const []});

  @override
  List<Object?> get props => [];
}

class UserListLoading extends UserState {}

class UserListSuccess extends UserState {
  const UserListSuccess(List<UserModel> userList) : super(userList: userList);
}

class UserListFailed extends UserState {}
