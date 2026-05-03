import '../../../data/models/deal_model.dart';

abstract class DealState {}

// Loading
class DealLoading extends DealState {}

// Success
class DealLoaded extends DealState {
  final List<Deal> allDeals;
  final List<Deal> filteredDeals;

  DealLoaded({
    required this.allDeals,
    required this.filteredDeals,
  });
}

// Error
class DealError extends DealState {
  final String message;
  DealError(this.message);
}