import 'package:notes/src/domain/repository/settings_repository.dart';

class GetSortByInteractor {
  Future<String> call(SettingsRepository settingsRepository) async {
    return settingsRepository.getSortByValue();
  }
}
