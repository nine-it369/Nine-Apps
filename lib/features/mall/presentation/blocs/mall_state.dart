import 'package:equatable/equatable.dart';
import '../../domain/entities/mall_entities.dart';

enum MallStatus { initial, loading, loaded, error }

class MallState extends Equatable {
  final MallStatus status;
  final List<MallCarouselEntity> carousels;
  final List<MallCategoryEntity> categories;
  final List<MallProductEntity> products;
  final int? selectedCategoryId;
  final String searchQuery;
  final String? errorMessage;

  const MallState({
    this.status = MallStatus.initial,
    this.carousels = const [],
    this.categories = const [],
    this.products = const [],
    this.selectedCategoryId,
    this.searchQuery = '',
    this.errorMessage,
  });

  List<MallProductEntity> get filteredProducts {
    var list = products;
    if (selectedCategoryId != null) {
      list = list.where((p) => p.categoryId == selectedCategoryId).toList();
    }
    if (searchQuery.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              p.productName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  MallState copyWith({
    MallStatus? status,
    List<MallCarouselEntity>? carousels,
    List<MallCategoryEntity>? categories,
    List<MallProductEntity>? products,
    int? selectedCategoryId,
    bool clearCategory = false,
    String? searchQuery,
    String? errorMessage,
  }) {
    return MallState(
      status: status ?? this.status,
      carousels: carousels ?? this.carousels,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        carousels,
        categories,
        products,
        selectedCategoryId,
        searchQuery,
        errorMessage,
      ];
}
