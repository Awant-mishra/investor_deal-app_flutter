abstract class DealEvent {}

// Load all deals
class LoadDeals extends DealEvent {}

// Search deals
class SearchDeals extends DealEvent {
  final String query;
  SearchDeals(this.query);
}

// Filter deals
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