import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class IAuthLocalDataSource {
  String? getToken();
  Future<void> saveToken(String token);
  UserModel? getCachedUser();
  Future<void> saveCachedUser(UserModel user);
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements IAuthLocalDataSource {
  final ApiClient apiClient;
  String? _token;
  UserModel? _cachedUser;

  AuthLocalDataSourceImpl(this.apiClient) {
    // Default fallback mock session for seamless offline/initial preview
    _cachedUser = const UserModel(
      id: 1,
      name: 'Aditya Pratama',
      phone: '08123456789',
      email: 'aditya.pratama@gmail.com',
      referralCode: 'AP-NINE99',
      nineKoinBalance: 2450,
      isActive: true,
      isVerified: true,
    );
  }

  @override
  String? getToken() => _token;

  @override
  Future<void> saveToken(String token) async {
    _token = token;
    apiClient.authInterceptor.setToken(token);
  }

  @override
  UserModel? getCachedUser() => _cachedUser;

  @override
  Future<void> saveCachedUser(UserModel user) async {
    _cachedUser = user;
  }

  @override
  Future<void> clearSession() async {
    _token = null;
    _cachedUser = null;
    apiClient.authInterceptor.setToken(null);
  }
}
