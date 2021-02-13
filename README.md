
### 介绍

Flutter client sdk of [`less-api`](https://github.com/Maslow/less-api).

### 安装

```sh
    flutter pub get install less-api-client
```

### 使用示例

```dart
import 'package:less_api_client/cloud.dart' ;

final cloud = new Cloud(entryUrl: 'http://localhost:8080/entry', getAccessToken: () => getToken(),);

final db = cloud.database();


// query documents
final cates = await db.collection('categories').get()

// query with options
final articles = await db.collection('articles')
    .where({})
    .orderBy({createdAt: 'asc'})
    .offset(0)
    .limit(20)
    .get()

// count documents
final total = await db.collection('articles').where({createdBy: 'the-user-id'}).count()

// update document
final updated = await db.collection('articles').doc('the-doc-id').update({
    title: 'new-title'
})

// add a document
final created = await db.collection('articles').add({
    title: "less api database",
    content: 'less api more life',
    createdAt: new Date("2019-09-01")
})

// delete a document
final removed = await db.collection('articles').doc('the-doc-id').remove()
```