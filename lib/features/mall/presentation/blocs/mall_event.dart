import 'package:equatable/equatable.dart';

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
