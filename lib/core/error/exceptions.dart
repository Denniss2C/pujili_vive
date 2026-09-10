class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
}

class DataException implements Exception {
  final String message;
  DataException([this.message = 'Data error']);
}
