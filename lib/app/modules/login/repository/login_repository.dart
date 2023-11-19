import '../../../data/model/user.dart';
import '../api/login_api.dart';

class LoginRepository {
  final LoginApi _api;
  LoginRepository(this._api);

  Future<User> getUser({
    required String deviceId,
  }) {
    try {
      return _api.getUser(deviceId: deviceId);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getBad() {
    try {
      return _api.getBad();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUser({required User user}) {
    try {
      return _api.updateUser(user: user);
    } catch (e) {
      rethrow;
    }
  }
}
