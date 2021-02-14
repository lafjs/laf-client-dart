import 'package:less_api_client/cloud.dart';
import 'package:less_api_client/database/types.dart';
import 'package:test/test.dart';

import '_config.dart';

// TIP: run less-api server before this testing!
final cloud = new Cloud(entryUrl: TestConfig.entryUrl);
final db = cloud.database();

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

  test('cloud where().get()', () async {
    final r = await db.collection("categories").where({"id": insertedId}).get();

    assert(r is GetResult);
    assert(r.data is List);
    expect(r.data[0]['id'], insertedId);
    expect(r.data[0]['name'], 'from dart sdk');
  });

  test('cloud where().get() with \$like operator', () async {
    final r = await db.collection("categories").where({
      "name": {"\$like": "%dart%"}
    }).get();

    assert(r is GetResult);
    assert(r.data is List);
    final len = r.data.length;
    final inserted = r.data[len - 1];

    expect(inserted['id'], insertedId);
    expect(inserted['name'], 'from dart sdk');
  });
}
