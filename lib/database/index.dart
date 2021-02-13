import 'package:less_api_client/database/collection.dart';
import 'package:less_api_client/database/param.dart';
import 'package:less_api_client/database/types.dart';

/**
 * 定义数据请求发送接口类
 */
abstract class RequestInterface {
  Future<ResponseResult> send(String action, Param param);
}

/**
 * 数据库模块
 * 
 * @author Maslow
 */
class Db {
  final RequestInterface request;

  Db(this.request);

  /**
   * 获取集合的引用
   * 
   * @param collName - 集合名称
   */
  CollectionReference collection(String collName) {
    if (collName.isEmpty) {
      throw Exception("Collection name is required");
    }

    return CollectionReference(this, collName);
  }

  /**
   * 创建集合(暂不需要)
   */
  // createCollection(String collName) {
  //   final params = Param(collName);

  //   return request.send(ActionType.ADD_COLLECTION, params);
  // }
}
