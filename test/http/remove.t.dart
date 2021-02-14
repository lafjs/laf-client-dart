import 'package:less_api_client/cloud.dart';
import 'package:less_api_client/database/types.dart';
import 'package:test/test.dart';

// TIP: run less-api server before this testing!
final cloud = new Cloud(entryUrl: "http://localhost:8080/entry");
final db = cloud.database();

// 此文件单独命名为 remove.t.dart，而不是 remove.test.dart
// 因为会操作删除数据操作, 与其它测试文件一起运行时 ，会影响其它测试用例结果
// pub run test test/http/remove.t.dart
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

  test("remove() one", () async {
    final r =
        await db.collection("categories").where({"id": insertedId}).remove();
    assert(r is RemoveResult);
    expect(r.deleted, 1);
  });

  test("remove() all", () async {
    final count = await db.collection("categories").count();

    final r = await db.collection("categories").remove(multi: true);
    assert(r is RemoveResult);

    expect(r.deleted, count.total);
  });
}
