abstract class SettingsRepository {
  Future<void> updateSortByValue(String sortBy);

  Future<void> updateSortOrderValue(String sortOrder);

  Future<String> getSortOrderValue();

  Future<String> getSortByValue();
}
