final class SearchParamsModel {
  final List<int> cities;
  final String search;

  const SearchParamsModel({
    this.cities = const [],
    this.search = '',
  });

  SearchParamsModel copyWith({
    List<int>? newCities,
    String? newSearch,
  }) {
    return SearchParamsModel(
      cities: newCities ?? cities,
      search: newSearch ?? search,
    );
  }
}
