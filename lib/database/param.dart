enum Direction { ASC, DESC }

class QueryOrder {
  String field;
  Direction direction = Direction.ASC;

  QueryOrder(this.field, {this.direction});

  Map<String, String> toJson() {
    return {
      "field": field,
      "direction": direction == Direction.DESC ? 'desc' : 'asc'
    };
  }

  static QueryOrder fromJson(data) {
    if (data == null) {
      return null;
    }
    final dir = data['direction'] == 'desc' ? Direction.DESC : Direction.ASC;
    return new QueryOrder(data['field'], direction: dir);
  }
}

class Param {
  String collectionName;
  Param(this.collectionName);

  static Param fromJson(data) {
    assert(data['collectionName'] != null, 'collectionName cannot be empty');
    return Param(data['collectionName']);
  }

  Map<String, dynamic> toJson() {
    return {"collectionName": collectionName};
  }
}

// 查询数据列表参数
class QueryParam extends Param {
  Object query;
  List<QueryOrder> order;
  int offset;
  int limit;
  Object projection;

  QueryParam(String collectionName, Object query,
      {List<QueryOrder> order, int limit, int offset, Object projection})
      : super(collectionName) {
    this.query = query ?? null;

    if (order != null) {
      assert(order is List, 'order must be List or null');
      this.order = [...order];
    }

    if (offset != null) {
      this.offset = offset;
    }

    // 最大不得超过 1000
    if (limit != null) {
      this.limit = limit < 1000 ? limit : 1000;
    }

    if (projection != null) {
      this.projection = projection;
    }
  }

  static QueryParam fromJson(data) {
    assert(data['collectionName'] != null, 'collectionName cannot be empty');

    final order = data['order'] == null
        ? null
        : (data['order'] as List).map((o) => QueryOrder.fromJson(o)).toList();

    return new QueryParam(data['collectionName'], data['query'],
        order: order,
        offset: data['offset'],
        limit: data['limit'],
        projection: data['projection']);
  }

  Map<String, dynamic> toJson() {
    assert(collectionName.isNotEmpty, 'collectionName cannot be empty');

    final _orders =
        order == null ? null : order.map((o) => o.toJson()).toList();

    Map<String, dynamic> param = {
      "collectionName": collectionName,
      "query": query ?? null,
      "order": _orders,
      "offset": offset ?? null,
      "limit": limit ?? null,
      "projection": projection ?? null
    };
    return param;
  }
}

// 更新数据参数
class UpdateParam extends QueryParam {
  // 是否允许批量操作，还是单条操作
  bool multi;
  // 是更新还是替换
  bool merge;

  Object data;

  UpdateParam(String collectionName, Object query, Object data, bool multi)
      : super(collectionName, query) {
    this.data = data;
    this.multi = multi;
  }

  @override
  Map<String, dynamic> toJson() {
    final ret = super.toJson();
    ret['data'] = data;
    ret['multi'] = multi;
    return ret;
  }

  static UpdateParam fromJson(_data) {
    assert(_data['collectionName'] != null, 'collectionName cannot be empty');

    return new UpdateParam(
        _data['collectionName'], _data['query'], _data['data'], _data['multi']);
  }
}

// 删除数据参数
class RemoveParam extends QueryParam {
  // 是否允许批量操作，还是单条操作
  bool multi;

  RemoveParam(String collectionName, Object query, bool multi)
      : super(collectionName, query) {
    this.multi = multi;
  }

  @override
  Map<String, dynamic> toJson() {
    final ret = super.toJson();
    ret['multi'] = multi;
    return ret;
  }

  static RemoveParam fromJson(_data) {
    assert(_data['collectionName'] != null, 'collectionName cannot be empty');

    return new RemoveParam(
        _data['collectionName'], _data['query'], _data['multi']);
  }
}

// 添加数据参数
class AddParam  extends Param{
  Object data;
  AddParam(String collectionName, this.data): super(collectionName);

  static AddParam fromJson(data) {
    assert(data['collectionName'] != null, 'collectionName cannot be empty');
    return AddParam(data['collectionName'], data['data']);
  }

  Map<String, dynamic> toJson() {
    return {"collectionName": collectionName, "data": data};
  }
}
