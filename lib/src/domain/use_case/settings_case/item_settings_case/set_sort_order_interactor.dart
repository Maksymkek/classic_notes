import 'package:notes/src/domain/repository/settings_repository.dart';

//TODO need to replace type from String to enum (SortOrder)
class SetSortOrderInteractor {
  void call(SettingsRepository settingsRepository, String sortOrder) {
    settingsRepository.updateSortOrderValue(sortOrder);
  }
}
