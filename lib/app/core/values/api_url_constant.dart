import '../../network/dio_provider.dart';

final baseUrl = DioProvider.baseUrl;

class ApiUrlConstants {
  static String register = '$baseUrl/api/register';

  static String login = '$baseUrl/api/login';

  static String update = '$baseUrl/api/update_username';

  static String getQuestions = '$baseUrl/api/questions';

  static String updateScore = '$baseUrl/api/update_score';

  static String getRank(String type) => '$baseUrl/api/toprank?type_time=$type';
}
