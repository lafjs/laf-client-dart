import 'package:less_api_client/cloud.dart';
import 'package:less_api_client/database/types.dart';
import 'package:test/test.dart';

import '_config.dart';

// TIP: run less-api server before this testing!
final cloud = new Cloud(entryUrl: TestConfig.entryUrl);
final db = cloud.database();

void main() {
  test("add()", () async {
    final r = await db.collection("categories").add({
      "name": "from dart sdk",
      "created_at": (DateTime.now().millisecondsSinceEpoch / 1000).ceil()
    });

    assert(r is AddResult);
    expect(r.insertedCount, 1);
  });
}
