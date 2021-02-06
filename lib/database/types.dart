// 请求响应结果
class ResponseResult<T> {
  final int code;
  final String requestId;
  T data;

  ResponseResult(this.code, this.data, this.requestId);
}

// 数据操作返回结果基类
abstract class BaseQueryResult {
  final String requestId;
  BaseQueryResult(this.requestId);
}

// get 操作返回结果
class GetResult extends BaseQueryResult {
  List<dynamic> data;
  GetResult(String requestId, this.data) : super(requestId);
}

// update 操作返回结果
class UpdateResult extends BaseQueryResult {
  final int updated;
  final int matched;
  final int upsertedId;
  UpdateResult(String requestId, this.updated, this.matched, this.upsertedId) : super(requestId);
}

// add 操作返回结果
class AddResult extends BaseQueryResult {
  AddResult(String requestId) : super(requestId);
}

// remove 操作返回结果
class RemoveResult extends BaseQueryResult {
  RemoveResult(String requestId) : super(requestId);
}

// count 操作返回结果
class CountResult extends BaseQueryResult {
  final int total;
  CountResult(String requestId, this.total) : super(requestId);
}

class ActionType {
  static const ADD_COLLECTION = "database.addCollection";
  static const QEURY_DOCUMENT = "database.queryDocument";
  static const COUNT_DOCUMENT = "database.countDocument";
  static const UPDATE_DOCUMENT = "database.updateDocument";
}
