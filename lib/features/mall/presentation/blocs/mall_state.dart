import 'package:equatable/equatable.dart';
import '../../domain/entities/mall_entities.dart';

enum MallStatus { initial, loading, loaded, error }

class MallState extends Equatable {
  final MallStatus status;
  final List<MallCarouselEntity> carousels;
  final List<MallCategoryEntity> categories;
  final List<MallProductEntity> products;
  final List<CartItemEntity> cartItems;
  final int? selectedCategoryId;
  final String searchQuery;
  final String? errorMessage;
  final String? successMessage;

  const MallState({
    this.status = MallStatus.initial,
    this.carousels = const [],
    this.categories = const [],
    this.products = const [],
    this.cartItems = const [],
    this.selectedCategoryId,
    this.searchQuery = '',
    this.errorMessage,
    this.successMessage,
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

  int get cartTotalQuantity => cartItems.fold(0, (sum, i) => sum + i.quantity);
  int get cartSelectedSubtotal =>
      cartItems.where((i) => i.isSelected).fold(0, (sum, i) => sum + i.subtotal);
  int get cartSelectedCount =>
      cartItems.where((i) => i.isSelected).fold(0, (sum, i) => sum + i.quantity);

  MallState copyWith({
    MallStatus? status,
    List<MallCarouselEntity>? carousels,
    List<MallCategoryEntity>? categories,
    List<MallProductEntity>? products,
    List<CartItemEntity>? cartItems,
    int? selectedCategoryId,
    bool clearCategory = false,
    String? searchQuery,
    String? errorMessage,
    String? successMessage,
  }) {
    return MallState(
      status: status ?? this.status,
      carousels: carousels ?? this.carousels,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        carousels,
        categories,
        products,
        cartItems,
        selectedCategoryId,
        searchQuery,
        errorMessage,
        successMessage,
      ];
}
