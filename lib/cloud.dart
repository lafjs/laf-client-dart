import 'package:less_api_client/request.dart';

import 'database/index.dart';

typedef String GetTokenFunction();

/**
 * 云开发入口类
 * 
 * @author Maslow
 */
class Cloud {
  String entryUrl;
  GetTokenFunction getAccessToken;
  int timeout;

  Cloud({this.entryUrl, this.getAccessToken, this.timeout});

  Db database() {
    final request = new Request(
        entryUrl: entryUrl, getTokenFunction: getAccessToken, timeout: timeout);

    return new Db(request);
  }
}
