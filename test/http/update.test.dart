import 'package:less_api_client/cloud.dart';
import 'package:less_api_client/database/types.dart';
import 'package:test/test.dart';

import '_config.dart';

// TIP: run less-api server before this testing!
final cloud = new Cloud(entryUrl: TestConfig.entryUrl);
final db = cloud.database();
// pub run test test/http/update.test.dart

void main() {
  int insertedId;

  test("add()", () async {
    final r = await db.collection("categories").add({
      "name": "from dart sdk",
      "created_at": (DateTime.now().millisecondsSinceEpoch / 1000).ceil()
    });

    assert(r is AddResult);
    expect(r.insertedCount, 1);
    insertedId = r.id;
  });

  test("update()", () async {
    final r = await db
        .collection("categories")
        .where({"id": insertedId}).update({"name": "update from dart"});

    assert(r is UpdateResult);
    expect(r.updated, 1);

    final read =
        await db.collection("categories").where({"id": insertedId}).get();

    expect(read.data.length, 1);
    expect(read.data[0]['name'], "update from dart");
  });

  test("update() with operator", () async {
    final data = {
      '\$set': {"name": "update from dart"},
      '\$inc': {"created_at": 1}
    };
    final r = await db
        .collection("categories")
        .where({"id": insertedId}).update(data);

    assert(r is UpdateResult);
    expect(r.updated, 1);

    final read =
        await db.collection("categories").where({"id": insertedId}).get();

    expect(read.data.length, 1);
    expect(read.data[0]['name'], "update from dart");
  });
}
