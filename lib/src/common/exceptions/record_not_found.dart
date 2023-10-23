class RecordNotFoundException implements Exception {
  final String message;
  RecordNotFoundException([this.message = 'Record not found']);
  @override
  String toString() => message;
}
