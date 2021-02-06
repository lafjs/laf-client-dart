import 'package:less_api_client/database/index.dart';
import 'package:less_api_client/database/param.dart';
import 'package:less_api_client/database/types.dart';

class TestRequest extends RequestInterface {
  // for testing use
  String action;
  Param data;

  @override
  Future<ResponseResult> send(String action, Param data) async {
    print("action: $action");
    print(data.toJson());
    this.action = action;
    this.data = data;

    if (action == ActionType.QEURY_DOCUMENT) {
      return ResponseResult(0, {"list": []}, "requestId");
    }

    if (action == ActionType.COUNT_DOCUMENT) {
      return ResponseResult(0, {"total": 0}, "requestId");
    }

    return ResponseResult(1, 'error', '');
  }
}
