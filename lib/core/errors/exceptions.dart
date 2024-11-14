class CustomeException implements Exception {
  final String message;

  CustomeException({required this.message});

  @override
  String toString() {
    return message;
  }
}