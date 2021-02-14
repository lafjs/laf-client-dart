
### 介绍

Flutter client sdk of [`less-api`](https://github.com/Maslow/less-api).

### 安装

请前往 pub.dev 查看[最新的 less_api_client 版本](https://pub.dev/packages/less_api_client).

在 pubspec.yaml 中添加依赖： 

```yaml
dependencies:
    less_api_client: ^0.0.4

```

通常IDE会自动执行更新依赖，或手动更新依赖：
```sh
  flutter pub get
```

### 使用示例

```dart
import 'package:less_api_client/cloud.dart' ;

final cloud = new Cloud(entryUrl: 'http://localhost:8080/entry', getAccessToken: () => getToken(),);

final db = cloud.database();


// query documents
final result = await db.collection('categories').get()

// query with options
final articles = await db.collection('articles')
    .where({})
    .orderBy({"createdAt": 'asc'})
    .offset(0)
    .limit(20)
    .get()

// count documents
final total = await db.collection('articles')
    .where({ "createdBy": 123})
    .count()

// update document
final updated = await db.collection('articles')
    .where({"id": 1})
    .update({
        "title": 'new-title'
    })

// add a document
final created = await db.collection('articles').add({
    "title": "less api database",
    "content": 'less api more life',
    "createdAt": Date.now()
})

// delete a document
final removed = await db.collection('articles')
    .where({ "id": 1 })
    .remove()
```


### 运行测试


#### unit test
```sh
pub run test test/db/*test.dart
```

#### http test

> TIP: 运行此测试之前，需要自行跑起一个可用的 less-api server 服务!!

```sh
pub run test test/http/*test.dart

# 删除数据的用例需要单独运行， 不然会影响其它操作的结果
pub run test test/http/remove.t.dart
```

#### all tests

```sh
pub run test test/**/*test.dart

# 删除数据的用例需要单独运行， 不然会影响其它操作的结果
pub run test test/http/remove.t.dart
```