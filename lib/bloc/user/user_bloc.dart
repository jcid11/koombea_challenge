import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koombea_test/bloc/user/user_event.dart';
import 'package:koombea_test/bloc/user/user_state.dart';
import 'package:koombea_test/data/home_interface.dart';
import 'package:koombea_test/service/home_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final HomeInterface _homeService;

  UserBloc({required HomeService homeService})
      : _homeService = homeService,
        super(const UserState()) {
    on<GetUserListEvent>(_loadUser);
  }

  void _loadUser(GetUserListEvent event, Emitter<UserState> emit) async {
    emit(UserListLoading());
    try {
      final result = await _homeService.getAllUser();
      emit(UserListSuccess(result.data));
    } catch (_) {
      emit(UserListFailed());
    }
  }
}
