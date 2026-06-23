class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

class ConflictException extends ApiException {
  const ConflictException(super.message);
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message);
}
