import 'package:less_api_client/cloud.dart';
import 'package:less_api_client/database/index.dart';
import 'package:less_api_client/database/types.dart';

class Request extends RequestInterface {
  // 获取 token 的方法
  GetTokenFunction getTokenFunction;

  // 超时时间
  int timeout = 5000;

  // 入口地址
  String entryUrl;

  Request({this.entryUrl, this.getTokenFunction, this.timeout});

  @override
  Future<ResponseResult> send(String action, Object data) async {
    // TODO: implement send
    return null;
  }
}
