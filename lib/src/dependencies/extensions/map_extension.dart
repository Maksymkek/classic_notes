import 'package:notes/src/domain/entity/item/item.dart';

extension ItemExtension on Map<dynamic, Item> {
  ///Returns new unique id
  int getId() {
    int lastId = 0;
    final idList = values.map((e) {
      if (lastId < e.id) {
        lastId = e.id;
      }
      return e.id;
    }).toList();
    if (idList.isEmpty) {
      return 0;
    }
    var newId = lastId + 1;
    return newId;
  }

  ///Returns key of the given [item] searched by [item.id]
  int getMapKey(Item item) {
    int searchedKey = -1;
    forEach((key, value) {
      if (value.id == item.id) {
        searchedKey = key;
        return;
      }
    });
    return searchedKey;
  }
}
