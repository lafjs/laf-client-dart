import 'package:less_api_client/database/collection.dart';
import 'package:less_api_client/database/index.dart';
import 'package:less_api_client/database/param.dart';
import 'package:less_api_client/database/query.dart';
import 'package:less_api_client/database/types.dart';
import "package:test/test.dart";
import '../utils.dart';
import '_request.dart';

// pub run test tests/db/where_test.dart
void main() {
  group("Query.where()", () {
    final req = new TestRequest();
    final db = new Db(req);
    final coll = db.collection("categories");

    test("collection().where({}) passed", () async {
      final r = await coll.where({}).get();
      assert(r is GetResult);
      expect(r.data, []);

      expect(req.action, ActionType.QEURY_DOCUMENT);
      final param = req.data as QueryParam;

      expect(param.collectionName, "categories");
      expect(param.query, {});
      expect(param.order, null);
      expect(param.offset, null);
      expect(param.limit, 100);
      expect(param.projection, null);
    });

    test("collection().where(params) passed", () async {
      final r = await coll.where({
        "id": 0,
        "age": {'\$gt': 0, '\$lt': 10}
      }).get();
      assert(r is GetResult);
      expect(r.data, []);

      expect(req.action, ActionType.QEURY_DOCUMENT);
      final param = req.data as QueryParam;

      print((param.query as Map).keys);

      expect(param.collectionName, "categories");
      expect(param.query, {'id': 0});

      final json_param = param.toJson();
      expect(json_param['query'], {'id': 0});
      expect(json_param['query']['id'], 0);
    });
  });
}
