abstract class DealEvent {}

class LoadDeals extends DealEvent {}

class SearchDeals extends DealEvent {
  final String query;
  SearchDeals(this.query);
}

class FilterDeals extends DealEvent {
  final String? risk;
  final String? industry;
  final double? minRoi;
  final double? maxRoi;

  FilterDeals({
    this.risk,
    this.industry,
    this.minRoi,
    this.maxRoi,
  });
}

class ClearFilters extends DealEvent {}