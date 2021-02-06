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
    if (res.code != 0) {
      return res.data;
    }

    GetResult ret = GetResult(res.requestId, res.data['list']);
    return ret;
  }

  /**
   * 获取总数
   */
  Future<CountResult> count() async {
    final param = QueryParam(_coll, this._fieldFitlers);

    final res = await _request.send(ActionType.COUNT_DOCUMENT, param);
    if (res.code != 0) {
      return res.data;
    }

    CountResult ret = CountResult(res.requestId, res.data['total']);
    return ret;
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
  Query orderBy(String field, Direction direction) {
    final newOrder = QueryOrder(field, direction: direction);
    List<QueryOrder> combinedOrders = [newOrder];
    if (_fieldOrders != null && _fieldOrders.length > 0) {
      combinedOrders.addAll(_fieldOrders);
    }

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
   * @TODO
   * 发起请求批量更新文档
   *
   * @param data 数据
   */
  Future<UpdateResult> update(Object data) async {
    final param = UpdateParam(_coll, this._fieldFitlers, data, true);

    final res = await _request.send(ActionType.UPDATE_DOCUMENT, param);
    if (res.code != 0) {
      return res.data;
    }

    int updated = res.data['updated'];
    int matched = res.data['matched'];
    int upsertedId = res.data['upsertedId'];
    final ret = UpdateResult(res.requestId, updated, matched, upsertedId);
    return ret;
  }

  /*
   * @TODO
   * 条件删除文档
   */
  Future<RemoveResult> remove() async {}
}
