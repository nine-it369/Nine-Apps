import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../garage/data/models/voucher_model.dart';
import '../models/customer_address_model.dart';
import '../models/customer_order_summary_model.dart';

abstract class IProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({
    required String name,
    String? email,
  });
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<List<VoucherModel>> getCustomerVouchers();
  Future<List<CustomerAddressModel>> getAddresses();
  Future<List<CustomerOrderSummaryModel>> getOrders();
}

class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final ApiClient garageApiClient;
  final ApiClient? mallApiClient;

  ProfileRemoteDataSourceImpl(
    this.garageApiClient, [
    this.mallApiClient,
  ]);

  ApiClient get _mallClient => mallApiClient ?? garageApiClient;

  @override
  Future<UserModel> getProfile() async {
    final response = await garageApiClient.get(ApiEndpoints.customerProfile);
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final userData = data['user'] as Map<String, dynamic>? ?? data;
      return UserModel.fromJson(userData);
    }
    throw const ServerException(message: 'Gagal memuat profil pengguna.');
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? email,
  }) async {
    final body = <String, dynamic>{
      'customer_name': name,
    };
    if (email != null) {
      body['email'] = email;
    }
    final response = await garageApiClient.put(
      ApiEndpoints.customerProfile,
      data: body,
    );
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final userData = data['user'] as Map<String, dynamic>? ?? data;
      return UserModel.fromJson(userData);
    }
    throw const ServerException(message: 'Gagal memperbarui profil pengguna.');
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await garageApiClient.post(
      '/auth/change-password',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );
    if (response.statusCode != 200) {
      throw const ServerException(message: 'Gagal memperbarui kata sandi.');
    }
  }

  @override
  Future<List<VoucherModel>> getCustomerVouchers() async {
    try {
      final response = await garageApiClient.get(ApiEndpoints.vouchers);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => VoucherModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<List<CustomerAddressModel>> getAddresses() async {
    try {
      final response = await _mallClient.get('/addresses');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => CustomerAddressModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<List<CustomerOrderSummaryModel>> getOrders() async {
    try {
      final response = await _mallClient.get('/orders');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => CustomerOrderSummaryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
