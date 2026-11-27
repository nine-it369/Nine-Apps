import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/mall_models.dart';

abstract class IMallRemoteDataSource {
  Future<List<MallCarouselModel>> getCarousels();
  Future<List<MallCategoryModel>> getCategories();
  Future<List<MallProductModel>> getVariants({
    int? categoryId,
    String? search,
    int limit = 20,
    int page = 1,
  });
}

class MallRemoteDataSourceImpl implements IMallRemoteDataSource {
  final ApiClient apiClient;

  MallRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<MallCarouselModel>> getCarousels() async {
    final response = await apiClient.get('/carousels');
    if (response.statusCode == 200 && response.data != null) {
      final raw = response.data['data'] as List<dynamic>? ?? [];
      return raw.map((e) => MallCarouselModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw const ServerException(message: 'Gagal memuat carousel mall.');
  }

  @override
  Future<List<MallCategoryModel>> getCategories() async {
    final response = await apiClient.get('/categories');
    if (response.statusCode == 200 && response.data != null) {
      final raw = response.data['data'] as List<dynamic>? ?? [];
      return raw.map((e) => MallCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw const ServerException(message: 'Gagal memuat kategori produk mall.');
  }

  @override
  Future<List<MallProductModel>> getVariants({
    int? categoryId,
    String? search,
    int limit = 20,
    int page = 1,
  }) async {
    final params = <String, dynamic>{
      'limit': limit,
      'page': page,
    };
    if (categoryId != null) {
      params['category_id'] = categoryId;
    }
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    final response = await apiClient.get(
      ApiEndpoints.variants,
      queryParameters: params,
    );

    if (response.statusCode == 200 && response.data != null) {
      final raw = response.data['data'] as List<dynamic>? ?? [];
      return raw.map((e) => MallProductModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw const ServerException(message: 'Gagal memuat daftar produk mall.');
  }
}
