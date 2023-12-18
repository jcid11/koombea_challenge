import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koombea_test/bloc/user/user_bloc.dart';
import 'package:koombea_test/bloc/user/user_state.dart';
import 'package:koombea_test/ui/add_user/add_user_screen.dart';
import 'package:koombea_test/ui/user_detail/user_detail_screen.dart';

import '../../bloc/user/user_event.dart';
import '../../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.microtask(
        () => BlocProvider.of<UserBloc>(context).add(GetUserListEvent()));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.red,
            size: 38,
          ),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddUserScreen()))),
      appBar: AppBar(
        title: const Text('These are all the users'),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, state) {
          if (state is UserListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is UserListFailed) {
            return const Center(
              child: Text('Something has fail here'),
            );
          }
          if (state is UserListSuccess) {
            List<UserModel> userList = state.userList!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDetailScreen(
                                    index: index, userModel: userList[index])));
                      },
                      child: Row(
                        children: [
                          Hero(
                            tag: index,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                userList[index].image,
                                width: 80,
                                height: 80,
                                filterQuality: FilterQuality.medium,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Material(
                            child: Column(
                              children: [
                                Text(
                                  "${userList[index].firstName} ${userList[index].lastName}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(userList[index].userName),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 20,
                    ),
                    itemCount: userList.length,
                  ))
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
