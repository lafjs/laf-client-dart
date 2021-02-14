import 'package:less_api_client/request.dart';
import 'database/index.dart';

typedef Future<String> GetTokenFunction();

abstract class CloudRequestInterface extends RequestInterface {
  // 获取 token 的方法
  GetTokenFunction getTokenFunction;

  // 超时时间
  int timeout = 5000;

  // 入口地址
  String entryUrl;

  CloudRequestInterface(this.entryUrl, {this.getTokenFunction, this.timeout});
}

/**
 * 云开发入口类
 * 
 * @author Maslow
 */
class Cloud {
  String entryUrl;
  GetTokenFunction getAccessToken;
  int timeout;

  Cloud({this.entryUrl, this.getAccessToken, this.timeout: 5000});

  Db database() {
    final request = new Request(entryUrl,
        getTokenFunction: getAccessToken, timeout: timeout);

    return new Db(request);
  }
}
