import 'package:less_api_client/database/query.dart';

import 'index.dart';

/**
 * 集合模块，继承 Query 模块
 *
 * @author Maslow
 */
class CollectionReference extends Query {
  /**
   * @param db    - 数据库的引用
   * @param coll  - 集合名称
   */
  CollectionReference(Db db, String coll) : super(db, coll) {}
}
