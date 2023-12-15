class WsResponse{
  final String? message;
  final dynamic data;
  final bool success;
  final int? statusCode;

  WsResponse({this.message, this.data, required this.success, this.statusCode});
}