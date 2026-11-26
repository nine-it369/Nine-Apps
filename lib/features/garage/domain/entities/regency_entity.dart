import 'package:equatable/equatable.dart';

class RegencyEntity extends Equatable {
  final int id;
  final String name;
  final int? provinceId;

  const RegencyEntity({
    required this.id,
    required this.name,
    this.provinceId,
  });

  @override
  List<Object?> get props => [id, name, provinceId];
}
