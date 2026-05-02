class CachedResource<T> {
  const CachedResource({
    required this.data,
    required this.isStale,
    this.cachedAt,
  });

  final T? data;
  final bool isStale;
  final DateTime? cachedAt;
}
