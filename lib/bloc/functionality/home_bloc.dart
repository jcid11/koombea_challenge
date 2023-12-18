import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koombea_test/bloc/functionality/home_event.dart';
import 'package:koombea_test/bloc/functionality/home_state.dart';
import 'package:koombea_test/service/home_service.dart';

import '../../data/home_interface.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeInterface _homeService;

  HomeBloc({required HomeService homeService})
      :_homeService=homeService,
        super(const HomeState()) {
    // on<GetUserListEvent>(_loadProfile);
    on<AddUserToListEvent>(_addUser);
    on<DeleteUserEvent>(_deleteUser);
  }


  // void _loadProfile(GetUserListEvent event, Emitter<HomeState>emit) async {
  //   emit(GetUserListLoading());
  //   try{
  //       final result = await _homeService.getAllUser();
  //   emit(GetUserListSuccess(result.data));
  //   }catch(_){
  //     emit(GetUserListFailed());
  //   }
  //   // emit(state.copyWith(homeStatus: HomeStatus.loading));
  //   // try {
  //   //   final result = await _homeService.getAllUser();
  //   //   emit(
  //   //       state.copyWith(homeStatus: HomeStatus.loaded, userList: result.data));
  //   // } catch (_) {
  //   //   emit(state.copyWith(homeStatus: HomeStatus.failed));
  //   // }
  // }

  void _addUser(AddUserToListEvent event, Emitter<HomeState> emit) async{
    emit(state.copyWith(addUserStatus: AddUserStatus.loading));
    try {
      final result = await _homeService.addUser(
          name: event.name, lastName: event.lastName, userName: event.userName);
      if(result.success) {
        emit(state.copyWith(addUserStatus: AddUserStatus.loaded));
        return ;
      }
      emit(state.copyWith(addUserStatus: AddUserStatus.failed));
    } catch (_) {
      emit(state.copyWith(addUserStatus: AddUserStatus.failed));
    }
  }

  void _deleteUser(DeleteUserEvent event,Emitter<HomeState> emit)async{
    emit(state.copyWith(deleteUserStatus: DeleteUserStatus.loading));
    try{
      final result = await _homeService.deleteUser(id: event.userID);
      if(result.success){
        emit(state.copyWith(deleteUserStatus: DeleteUserStatus.success));
      }
    }catch(_){
      emit(state.copyWith(deleteUserStatus: DeleteUserStatus.failed));
    }
  }
}