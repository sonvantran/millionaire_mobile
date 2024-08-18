import 'base_api_exception.dart';

class BadRequestException extends BaseApiException {
  BadRequestException({
    required super.httpCode,
    required super.status,
    super.message,
  });
}
