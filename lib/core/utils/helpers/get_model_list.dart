List<T> getModelList<T>(
    dynamic data, T Function(Map<String, dynamic>) fromMap) {
  return List<Map<String, dynamic>>.from(data).map(fromMap).toList();
}
