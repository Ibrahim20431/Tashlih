// Make search as class to make provider update when pass text as same as old text
final class SearchModel {
  SearchModel(this.text);

  final String text;
  final DateTime updated = DateTime.now();
}
