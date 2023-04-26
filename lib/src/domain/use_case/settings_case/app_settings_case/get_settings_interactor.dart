import 'package:notes/src/data/repository/app_settings_repository.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';

class GetSettingsInteractor {
  GetSettingsInteractor(this.appSettingsRepository);
  AppSettingsRepository appSettingsRepository;
  Future<AppSettings> call() async {
    return appSettingsRepository.getSettings();
  }
}
