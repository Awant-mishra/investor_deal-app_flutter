import '../../../data/models/deal_model.dart';
import 'package:equatable/equatable.dart';

abstract class DealState extends Equatable {
  const DealState();

  @override
  List<Object?> get props => [];
}

///  Loading
class DealLoading extends DealState {}

///  Loaded
class DealLoaded extends DealState {
  final List<Deal> allDeals;
  final List<Deal> filteredDeals;

  const DealLoaded({
    required this.allDeals,
    required this.filteredDeals,
  });

  @override
  List<Object?> get props => [allDeals, filteredDeals];
}

///  Error
class DealError extends DealState {
  final String message;

  const DealError(this.message);

  @override
  List<Object?> get props => [message];
}