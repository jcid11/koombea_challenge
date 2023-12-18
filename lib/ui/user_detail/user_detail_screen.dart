import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koombea_test/bloc/functionality/home_event.dart';
import 'package:koombea_test/bloc/functionality/home_state.dart';
import 'package:koombea_test/models/user_model.dart';
import 'package:koombea_test/utils/alert_dialog.dart';

import '../../bloc/functionality/home_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';

class UserDetailScreen extends StatelessWidget {
  final int index;
  final UserModel userModel;

  const UserDetailScreen(
      {Key? key, required this.index, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (BuildContext context, state) {
        if (state.deleteUserStatus == DeleteUserStatus.loading) {
          loadingDialog(context);
        } else if (state.deleteUserStatus == DeleteUserStatus.success) {
          Navigator.pop(context);
          Navigator.pop(context);
          BlocProvider.of<UserBloc>(context).add(GetUserListEvent());
        } else if (state.deleteUserStatus == DeleteUserStatus.failed) {
          Navigator.pop(context);
          failDialog(context);
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => BlocProvider.of<HomeBloc>(context)
              .add(DeleteUserEvent(userID: index + 1)),
          child: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
        appBar: AppBar(
          title: const Text('User details'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: ()=>Navigator.pop(context),
              child: Hero(
                tag: index,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    userModel.image,
                    width: 180,
                    height: 180,
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              child: Column(
                children: [
                  Center(
                      child:
                      Text("${userModel.firstName} ${userModel.lastName}")),
                  Center(child: Text(userModel.userName)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
