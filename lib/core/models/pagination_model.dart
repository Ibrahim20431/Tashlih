final class PaginationModel<T> {
  late final int currentPage;
  late final int lastPage;
  late final bool isLastPage;
  late final List<T> list;

  void setData({
    required Map<String, dynamic> map,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final data = List<Map<String, dynamic>>.from(map['data']);
    currentPage = map['current_page'];
    lastPage = map['last_page'];
    isLastPage = currentPage == lastPage;
    list = List<T>.from(data.map(fromJson));
  }
}
