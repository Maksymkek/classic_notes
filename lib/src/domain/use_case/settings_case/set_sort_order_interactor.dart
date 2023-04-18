import 'package:notes/src/domain/repository/settings_repository.dart';

class SetSortOrderInteractor {
  void call(SettingsRepository settingsRepository, String sortOrder) {
    settingsRepository.updateSortOrderValue(sortOrder);
  }
}
