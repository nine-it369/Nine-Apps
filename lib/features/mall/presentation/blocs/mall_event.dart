import 'package:equatable/equatable.dart';
import '../../domain/entities/mall_entities.dart';

abstract class MallEvent extends Equatable {
  const MallEvent();

  @override
  List<Object?> get props => [];
}

class InitMallEvent extends MallEvent {
  const InitMallEvent();
}

class FilterMallCategoryEvent extends MallEvent {
  final int? categoryId;

  const FilterMallCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SearchMallProductEvent extends MallEvent {
  final String query;

  const SearchMallProductEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddToCartEvent extends MallEvent {
  final MallProductEntity product;
  final int quantity;
  final bool withInstallation;

  const AddToCartEvent({
    required this.product,
    this.quantity = 1,
    this.withInstallation = false,
  });

  @override
  List<Object?> get props => [product, quantity, withInstallation];
}

class UpdateCartQuantityEvent extends MallEvent {
  final int cartItemId;
  final int delta;

  const UpdateCartQuantityEvent({
    required this.cartItemId,
    required this.delta,
  });

  @override
  List<Object?> get props => [cartItemId, delta];
}

class ToggleCartItemSelectionEvent extends MallEvent {
  final int cartItemId;

  const ToggleCartItemSelectionEvent(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class ToggleAllCartSelectionEvent extends MallEvent {
  final bool isSelected;

  const ToggleAllCartSelectionEvent(this.isSelected);

  @override
  List<Object?> get props => [isSelected];
}

class RemoveCartItemEvent extends MallEvent {
  final int cartItemId;

  const RemoveCartItemEvent(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class ClearCartEvent extends MallEvent {
  const ClearCartEvent();
}
