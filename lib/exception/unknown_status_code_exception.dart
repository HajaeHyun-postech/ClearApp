class UnknownStatusCodeException implements Exception {
  String cause;
  UnknownStatusCodeException(this.cause);
}
