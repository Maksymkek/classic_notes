import 'package:notes/src/domain/repository/settings_repository.dart';

class GetSortOrderInteractor {
  Future<String> call(SettingsRepository settingsRepository) async {
    return settingsRepository.getSortOrderValue();
  }
}
