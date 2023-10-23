class FormDirtyException implements Exception {
  final String message;
  FormDirtyException(
      [this.message =
          'Form not yet saved, would you like to discard the changes you made?']);
  @override
  String toString() => message;
}
