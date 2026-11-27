import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
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
      (data) => emit(state.copyWith(
        status: MallStatus.loaded,
        carousels: data.carousels,
        categories: data.categories,
        products: data.products,
      )),
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
}
