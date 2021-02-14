// 请求响应结果
class ResponseResult<T> {
  final int code;
  final String requestId;
  T data;

  ResponseResult(this.code, this.data, this.requestId);
}

// 数据操作返回结果基类
abstract class BaseQueryResult {
  final ResponseResult res;
  String get requestId => res.requestId;
  bool get ok => res.code == 0;
  dynamic get error {
    return ok ? null : res.data;
  }

  BaseQueryResult(this.res);
}

// get 操作返回结果
class GetResult extends BaseQueryResult {
  List<dynamic> get data => res.data['list'];
  GetResult(ResponseResult res) : super(res);
}

// update 操作返回结果
class UpdateResult extends BaseQueryResult {
  int get updated => res.data['updated'];
  int get matched => res.data['matched'];
  int get upsertedId => res.data['upsertedId'];

  UpdateResult(ResponseResult res) : super(res);
}

// add 操作返回结果
class AddResult extends BaseQueryResult {
  get id => res.data['_id'];
  int get insertedCount => res.data['insertedCount'];
  AddResult(ResponseResult res) : super(res);
}

// remove 操作返回结果
class RemoveResult extends BaseQueryResult {
  int get deleted => res.data['deleted'];

  RemoveResult(ResponseResult res) : super(res);
}

// count 操作返回结果
class CountResult extends BaseQueryResult {
  int get total => res.data['total'];
  CountResult(ResponseResult res) : super(res);
}

class ActionType {
  static const ADD_COLLECTION = "database.addCollection";
  static const QEURY_DOCUMENT = "database.queryDocument";
  static const COUNT_DOCUMENT = "database.countDocument";
  static const UPDATE_DOCUMENT = "database.updateDocument";
  static const REMOVE_DOCUMENT = "database.deleteDocument";
  static const ADD_DOCUMENT = "database.addDocument";
}
