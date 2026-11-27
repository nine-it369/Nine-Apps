import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  });

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.loginOtp,
      data: {
        'customer_phone': phone,
        'password': password,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return data;
    }
    throw const ServerException(message: 'Gagal melakukan login.');
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      data: {
        'customer_name': name,
        'customer_phone': phone,
        'password': password,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return data;
    }
    throw const ServerException(message: 'Gagal melakukan pendaftaran akun.');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get(ApiEndpoints.customerProfile);
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final userData = data['user'] as Map<String, dynamic>? ?? data;
      return UserModel.fromJson(userData);
    }
    throw const ServerException(message: 'Gagal memuat profil pengguna.');
  }
}
