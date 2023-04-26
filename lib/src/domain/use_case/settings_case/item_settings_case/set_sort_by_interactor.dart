import 'package:notes/src/domain/repository/settings_repository.dart';

class SetSortByInteractor {
  void call(SettingsRepository settingsRepository, String sortBy) {
    settingsRepository.updateSortByValue(sortBy);
  }
}
