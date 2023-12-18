import 'dart:convert';

import 'package:koombea_test/data/home_interface.dart';
import 'package:http/http.dart' as http;
import 'package:koombea_test/utils/ws_response.dart';

import '../models/user_model.dart';

class HomeService implements HomeInterface {
  final http.Client client;

  HomeService({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<WsResponse> getAllUser() async {
    String url = 'https://jserver-api.herokuapp.com/users';
    final http.Response response = await client.get(Uri.parse(url));
    List<dynamic> jsonList = jsonDecode(response.body) as List;
    // List<UserModel> userList = [];
    try {
      if (response.statusCode == 200) {
        List<UserModel> userList = jsonList
            .map((element) => UserModel(
                firstName: element['firstName'],
                lastName: element['lastName'],
                image: element['pictureURL'],
                userName: element['twitterHandle']))
            .toList();

        return WsResponse(success: true, data: userList);
      }
    } catch (_) {
      return WsResponse(success: false);
    }
    return WsResponse(success: false);
  }

  @override
  Future<WsResponse> addUser(
      {required String name,
      required String lastName,
      required String userName}) async {
    Map body = {
      "firstName": name,
      "lastName": lastName,
      "twitterHandle": userName,
      "pictureURL": "https://randomuser.me/api/portraits/women/2.jpg"
    };
    String url = 'https://jserver-api.herokuapp.com/users';
    final http.Response response =
        await client.post(Uri.parse(url), body: body);
    try {
      return WsResponse(success: response.statusCode == 201 ? true : false);
    } catch (_) {
      return WsResponse(success: false);
    }
  }

  @override
  Future<WsResponse> deleteUser({required int id}) async {
    String url = 'https://jserver-api.herokuapp.com/users/$id';
    final http.Response response = await client.delete(Uri.parse(url));
    try {
      return WsResponse(success: response.statusCode == 200 ? true : false);
    } catch (_) {
      return WsResponse(success: false);
    }
  }
}
