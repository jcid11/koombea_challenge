import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koombea_test/bloc/home_event.dart';
import 'package:koombea_test/bloc/home_state.dart';
import 'package:koombea_test/utils/alert_dialog.dart';

import '../../bloc/home_bloc.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (BuildContext context, state) {
        if (state.addUserStatus == AddUserStatus.loading) {
          loadingDialog(context);
        }
        if (state.addUserStatus == AddUserStatus.loaded) {
          Navigator.pop(context);
          Navigator.pop(context);
          BlocProvider.of<HomeBloc>(context).add(GetUserListEvent());
        }
        if (state.addUserStatus == AddUserStatus.failed) {
          Navigator.pop(context);
          failDialog(context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Adding user screen'),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Text('Save user information')),
                  const Text('Name'),
                  TextFormField(
                    controller: name,
                  ),
                  const SizedBox(height: 10,),
                  const Text('Last name'),
                  TextFormField(
                    controller: lastName,
                  ),
                  const SizedBox(height: 10,),

                  const Text('User Name'),
                  TextFormField(
                    controller: userName,
                  ),
                  const Spacer(),
                  RawMaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<HomeBloc>(context).add(
                            AddUserToListEvent(
                                name: name.text,
                                lastName: lastName.text,
                                userName: userName.text));
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
