import 'package:less_api_client/database/index.dart';
import 'package:less_api_client/database/param.dart';
import 'package:less_api_client/database/types.dart';

/**
 * 查询模块
 *
 * @author Maslow
 */
class Query {
  // Db 的引用
  final Db _db;

  // Collection name
  final String _coll;

  String get collectionName => _coll;

  // 过滤条件
  Object _fieldFitlers;

  // 排序条件
  List<QueryOrder> _fieldOrders;

  // 查询条数
  int _limit = 100;

  // 偏移量
  int _offset = 0;

// 指定显示或者不显示哪些字段
  Object _projection;

  // 请求实例
  RequestInterface get _request => _db.request;

  /**
   * 初始化
   *
   * @param db            - 数据库的引用
   * @param coll          - 集合名称
   * @param fieldFilters  - 过滤条件
   * @param fieldOrders   - 排序条件
   * @param queryOptions  - 查询条件
   */
  Query(this._db, this._coll,
      {Object fieldFitlers,
      List<QueryOrder> fieldOrders,
      int limit,
      int offset,
      Object projection}) {
    _fieldFitlers = fieldFitlers;
    _fieldOrders = fieldOrders ?? null;
    _limit = limit;
    _offset = offset;
    _projection = projection ?? null;
  }

  /**
   * 发起请求获取文档列表
   *
   * - 默认获取集合下全部文档数据
   * - 可以把通过 `orderBy`、`where`、`skip`、`limit`设置的数据添加请求参数上
   */
  // ignore: missing_return
  Future<GetResult> get() async {
    // 默认 limit 为 100
    if (this._limit == null) {
      this._limit = 100;
    }

    final param = QueryParam(
      _coll,
      this._fieldFitlers,
      order: this._fieldOrders,
      limit: this._limit,
      offset: this._offset,
      projection: this._projection,
    );

    final res = await _request.send(ActionType.QEURY_DOCUMENT, param);

    return GetResult(res);
  }

  /**
   * 获取总数
   */
  Future<CountResult> count() async {
    final param = QueryParam(_coll, this._fieldFitlers);

    final res = await _request.send(ActionType.COUNT_DOCUMENT, param);

    return CountResult(res);
  }

  /**
   * 查询条件
   * 
   * @param query
   */
  Query where(Object query) {
    if (query == null) {
      throw new Exception("查询参数对象值不能为空");
    }

    return new Query(_db, _coll,
        fieldFitlers: query,
        fieldOrders: this._fieldOrders,
        limit: this._limit,
        offset: this._offset,
        projection: this._projection);
  }

  /**
   * 设置排序方式
   * 
   * @param field       - 字段名
   * @param direction   - 排序方式
   */
  Query orderBy(String field, {Direction direction: Direction.ASC}) {
    List<QueryOrder> combinedOrders = [];
    if (_fieldOrders != null && _fieldOrders.length > 0) {
      combinedOrders.addAll(_fieldOrders);
    }

    final newOrder = QueryOrder(field, direction: direction);
    combinedOrders.add(newOrder);

    return new Query(_db, _coll,
        fieldFitlers: this._fieldFitlers,
        fieldOrders: combinedOrders,
        limit: this._limit,
        offset: this._offset,
        projection: this._projection);
  }

  /**
   * 设置查询条数
   *
   * @param limit - 限制条数
   */
  Query limit(int limit) {
    assert(limit >= 0, 'limit must >= 0');

    return new Query(_db, _coll,
        fieldFitlers: this._fieldFitlers,
        fieldOrders: this._fieldOrders,
        limit: limit,
        offset: this._offset,
        projection: this._projection);
  }

  /**
   * 设置偏移量
   *
   * @param offset - 偏移量
   */
  Query skip(int offset) {
    assert(offset > 0, 'offset must > 0');

    return new Query(_db, _coll,
        fieldFitlers: this._fieldFitlers,
        fieldOrders: this._fieldOrders,
        limit: this._limit,
        offset: offset,
        projection: this._projection);
  }

  /**
   * 指定要返回的字段
   *
   * @param projection
   */
  Query field(Object projection) {
    // @TODO deal with projection

    return new Query(_db, _coll,
        fieldFitlers: this._fieldFitlers,
        fieldOrders: this._fieldOrders,
        limit: this._limit,
        offset: this._offset,
        projection: projection);
  }

  /**
   * 发起请求更新文档
   *
   * @param data 数据
   */
  Future<UpdateResult> update(Object data, {bool multi: false}) async {
    assert(data != null, 'Query::update() data cannot be null object');

    final param =
        UpdateParam(_coll, this._fieldFitlers, _buildUpdateData(data), multi);

    final res = await _request.send(ActionType.UPDATE_DOCUMENT, param);
    return UpdateResult(res);
  }

  /*
   * 条件删除文档
   */
  Future<RemoveResult> remove({bool multi: false}) async {
    final param = RemoveParam(_coll, this._fieldFitlers, multi);

    final res = await _request.send(ActionType.REMOVE_DOCUMENT, param);

    return RemoveResult(res);
  }

  /**
   * 添加一篇文档
   *
   * @param data - 数据
   */
  Future<AddResult> add(Object data) async {
    assert(data != null, 'Query::update() data cannot be null object');

    final param = AddParam(_coll, data);

    final res = await _request.send(ActionType.ADD_DOCUMENT, param);

    return AddResult(res);
  }

  Object _buildUpdateData(Object raw) {
    final update_opeartors = Set.from(["\$set", '\$unset', '\$inc', '\$mul']);

    final noOperator =
        (raw as Map).keys.every((key) => !update_opeartors.contains(key));

    if (noOperator) {
      return {"\$set": raw};
    }

    return raw;
  }
}
