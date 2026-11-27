import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/mall_entities.dart';
import '../../domain/repositories/i_mall_repository.dart';
import '../../domain/usecases/mall_usecases.dart';
import 'mall_event.dart';
import 'mall_state.dart';

class MallBloc extends Bloc<MallEvent, MallState> {
  final GetMallHomeDataUseCase getMallHomeDataUseCase;
  final IMallRepository repository;

  MallBloc({
    required this.getMallHomeDataUseCase,
    required this.repository,
  }) : super(const MallState()) {
    on<InitMallEvent>(_onInit);
    on<FilterMallCategoryEvent>(_onFilterCategory);
    on<SearchMallProductEvent>(_onSearchProduct);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
    on<ToggleCartItemSelectionEvent>(_onToggleCartItemSelection);
    on<ToggleAllCartSelectionEvent>(_onToggleAllCartSelection);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onInit(
    InitMallEvent event,
    Emitter<MallState> emit,
  ) async {
    emit(state.copyWith(status: MallStatus.loading));
    final result = await getMallHomeDataUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: MallStatus.error,
        errorMessage: failure.message,
      )),
      (data) {
        // Initial sample items for cart if empty
        final initialCart = state.cartItems.isEmpty && data.products.length >= 2
            ? [
                CartItemEntity(
                  id: 1,
                  product: data.products[0],
                  quantity: 1,
                  warehouseName: 'Gudang Utama Jakarta',
                  isSelected: true,
                  withInstallation: true,
                ),
                CartItemEntity(
                  id: 2,
                  product: data.products[1],
                  quantity: 1,
                  warehouseName: 'Gudang Utama Jakarta',
                  isSelected: true,
                  withInstallation: false,
                ),
              ]
            : state.cartItems;

        emit(state.copyWith(
          status: MallStatus.loaded,
          carousels: data.carousels,
          categories: data.categories,
          products: data.products,
          cartItems: initialCart,
        ));
      },
    );
  }

  Future<void> _onFilterCategory(
    FilterMallCategoryEvent event,
    Emitter<MallState> emit,
  ) async {
    if (state.selectedCategoryId == event.categoryId) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategoryId: event.categoryId));
    }
  }

  Future<void> _onSearchProduct(
    SearchMallProductEvent event,
    Emitter<MallState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onAddToCart(
    AddToCartEvent event,
    Emitter<MallState> emit,
  ) {
    final existingIndex = state.cartItems.indexWhere((i) => i.product.id == event.product.id);
    List<CartItemEntity> updatedItems = List.from(state.cartItems);

    if (existingIndex >= 0) {
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + event.quantity,
        withInstallation: event.withInstallation,
      );
    } else {
      final newId = updatedItems.isEmpty ? 1 : (updatedItems.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);
      updatedItems.add(
        CartItemEntity(
          id: newId,
          product: event.product,
          quantity: event.quantity,
          withInstallation: event.withInstallation,
          isSelected: true,
        ),
      );
    }

    emit(state.copyWith(
      cartItems: updatedItems,
      successMessage: '${event.product.name} ditambahkan ke keranjang.',
    ));
  }

  void _onUpdateCartQuantity(
    UpdateCartQuantityEvent event,
    Emitter<MallState> emit,
  ) {
    final updated = state.cartItems.map((item) {
      if (item.id == event.cartItemId) {
        final newQty = item.quantity + event.delta;
        return newQty > 0 ? item.copyWith(quantity: newQty) : item;
      }
      return item;
    }).toList();

    emit(state.copyWith(cartItems: updated));
  }

  void _onToggleCartItemSelection(
    ToggleCartItemSelectionEvent event,
    Emitter<MallState> emit,
  ) {
    final updated = state.cartItems.map((item) {
      if (item.id == event.cartItemId) {
        return item.copyWith(isSelected: !item.isSelected);
      }
      return item;
    }).toList();

    emit(state.copyWith(cartItems: updated));
  }

  void _onToggleAllCartSelection(
    ToggleAllCartSelectionEvent event,
    Emitter<MallState> emit,
  ) {
    final updated = state.cartItems.map((item) {
      return item.copyWith(isSelected: event.isSelected);
    }).toList();

    emit(state.copyWith(cartItems: updated));
  }

  void _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<MallState> emit,
  ) {
    final updated = state.cartItems.where((i) => i.id != event.cartItemId).toList();
    emit(state.copyWith(cartItems: updated));
  }

  void _onClearCart(
    ClearCartEvent event,
    Emitter<MallState> emit,
  ) {
    emit(state.copyWith(cartItems: []));
  }
}
