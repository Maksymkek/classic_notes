import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';

mixin ScreenRedraw {
  bool needRedraw(
    ScreenState<Item> current,
    ScreenState<Item> prev,
  ) {
    bool needToRedraw = current.items.length != prev.items.length ||
        current.settings.sortOrder != prev.settings.sortOrder ||
        current.settings.sortBy != prev.settings.sortBy;
    if (needToRedraw) {
      return true;
    }
    for (int i = 0; i < current.items.length; i += 1) {
      if (current.items[i]?.dateOfLastChange !=
          prev.items[i]?.dateOfLastChange) {
        return true;
      }
    }
    return false;
  }
}
