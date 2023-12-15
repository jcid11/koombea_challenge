import '../utils/ws_response.dart';

abstract class HomeInterface{
  Future<WsResponse> getAllUser();
  Future<WsResponse> addUser({required String name,required String lastName,required String userName});
  Future<WsResponse> deleteUser({required int id});
}