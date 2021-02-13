import 'package:less_api_client/database/collection.dart';
import 'package:less_api_client/database/index.dart';
import 'package:less_api_client/database/param.dart';
import 'package:less_api_client/database/query.dart';
import 'package:less_api_client/database/types.dart';
import "package:test/test.dart";
import '../utils.dart';
import '_request.dart';

// pub run test tests/db/db_test.dart
void main() {
  group('class Db', () {
    test("constructor passed", () {
      final db = new Db(new TestRequest());
      expect(typeof(db), "Db");
      assert(db is Db);
    });

    test("collection() passed", () {
      final db = new Db(new TestRequest());
      final coll = db.collection("categories");
      assert(coll is CollectionReference);
      assert(coll is Query);
    });

        test("collection().get() passed", () async {
      final req = new TestRequest();
      final db = new Db(req);
      final coll = db.collection("categories");
      assert(coll is CollectionReference);
      assert(coll is Query);

      final r = await coll.get();
      assert(r is GetResult);
      expect(r.data, []);

      expect(req.action, ActionType.QEURY_DOCUMENT);
      final param = req.data as QueryParam;

      expect(param.collectionName, "categories");
      expect(param.query, null);
      expect(param.order, null);
      expect(param.offset, null);
      expect(param.limit, 100);
      expect(param.projection, null);
    });

    test("collection().count() passed", () async {
      final req = new TestRequest();
      final db = new Db(req);

      final r = await db.collection("categories").count();
      assert(r is CountResult);
      expect(r.total, 0);

      expect(req.action, ActionType.COUNT_DOCUMENT);
      final param = req.data as QueryParam;

      expect(param.collectionName, "categories");
      expect(param.query, null);
      expect(param.order, null);
      expect(param.offset, null);
      expect(param.limit, null);
      expect(param.projection, null);
    });

  });
}
