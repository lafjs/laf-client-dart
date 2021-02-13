import 'package:less_api_client/database/collection.dart';
import 'package:less_api_client/database/index.dart';
import 'package:less_api_client/database/param.dart';
import 'package:less_api_client/database/query.dart';
import 'package:less_api_client/database/types.dart';
import "package:test/test.dart";
import '_request.dart';

// pub run test tests/db/query_test.dart
void main() {
  group("class Query", () {
    test('Query.field', () async {
      final req = new TestRequest();
      final db = new Db(req);
      final coll = db.collection("categories");
      assert(coll is CollectionReference);
      assert(coll is Query);

      final r = await coll.field({"ok": true, "f1": 1}).get();
      assert(r is GetResult);
      expect(r.data, []);

      expect(req.action, ActionType.QEURY_DOCUMENT);
      final param = req.data as QueryParam;

      expect(param.collectionName, "categories");
      expect(param.query, null);
      expect(param.order, null);
      expect(param.offset, null);
      expect(param.limit, 100);
      expect((param.projection as dynamic)['ok'], true);
      expect((param.projection as dynamic)['f1'], 1);

      final json_param = param.toJson();
      dynamic proj = json_param['projection'];
      expect(proj['ok'], true);
      expect(proj['f1'], 1);
    });

    test('Query.orderBy', () async {
      final req = new TestRequest();
      final db = new Db(req);
      final coll = db.collection("categories");
      assert(coll is CollectionReference);
      assert(coll is Query);

      final r = await coll
          .field({"ok": true, "f1": 1})
          .orderBy('f1')
          .orderBy('ok', direction: Direction.DESC)
          .get();
      assert(r is GetResult);
      expect(r.data, []);

      expect(req.action, ActionType.QEURY_DOCUMENT);
      final param = req.data as QueryParam;

      expect(param.collectionName, "categories");
      expect(param.query, null);
      expect(param.offset, null);
      expect(param.limit, 100);
      expect(param.order.length, 2);
      expect(param.order[0].field, 'f1');
      expect(param.order[0].direction, Direction.ASC);
      expect(param.order[1].field, 'ok');
      expect(param.order[1].direction, Direction.DESC);

      final json_param = param.toJson();
      List order = json_param['order'];
      expect(order.length, 2);
      expect(order[0]['field'], 'f1');
      expect(order[0]['direction'], 'asc');
      expect(order[1]['field'], 'ok');
      expect(order[1]['direction'], 'desc');
    });

    test('Query.offset & limit', () async {
      final req = new TestRequest();
      final db = new Db(req);
      final coll = db.collection("categories");

      final r = await coll
          .field({"ok": true, "f1": 1})
          .orderBy('f1')
          .orderBy('ok', direction: Direction.DESC)
          .skip(10)
          .limit(2)
          .get();
      assert(r is GetResult);
      expect(r.data, []);

      expect(req.action, ActionType.QEURY_DOCUMENT);
      final param = req.data as QueryParam;

      expect(param.collectionName, "categories");
      expect(param.query, null);
      expect(param.offset, 10);
      expect(param.limit, 2);
      expect(param.order.length, 2);
      expect(param.order[0].field, 'f1');
      expect(param.order[0].direction, Direction.ASC);
      expect(param.order[1].field, 'ok');
      expect(param.order[1].direction, Direction.DESC);

      final json_param = param.toJson();
      List order = json_param['order'];
      expect(order.length, 2);
      expect(order[0]['field'], 'f1');
      expect(order[0]['direction'], 'asc');
      expect(order[1]['field'], 'ok');
      expect(order[1]['direction'], 'desc');
    });
  });
}
