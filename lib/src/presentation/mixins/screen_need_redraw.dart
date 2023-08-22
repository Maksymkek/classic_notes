import 'package:notes/src/domain/entity/item/item.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';

mixin ScreenRedraw {
  bool needRedraw(
    ScreenState<Item> current,
    ScreenState<Item> prev,
  ) {
    bool needToRedraw = current.items != prev.items ||
        current.settings.sortOrder != prev.settings.sortOrder ||
        current.settings.sortBy != prev.settings.sortBy;
    if (needToRedraw) {
      return true;
    }
    return false;
  }
}
