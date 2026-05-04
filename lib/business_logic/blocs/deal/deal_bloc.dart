import 'package:flutter_bloc/flutter_bloc.dart';
import 'deal_event.dart';
import 'deal_state.dart';
import '../../../data/models/deal_model.dart';
import '../../../data/repositories/deal_repository.dart';

class DealBloc extends Bloc<DealEvent, DealState> {
  final DealRepository repository;

  List<Deal> allDeals = [];

  String? currentRisk;
  String? currentIndustry;
  double? currentMinRoi;
  double? currentMaxRoi;
  String currentSearch = "";

  DealBloc(this.repository) : super(DealLoading()) {
    on<LoadDeals>(_onLoadDeals);
    on<SearchDeals>(_onSearchDeals);
    on<FilterDeals>(_onFilterDeals);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadDeals(
      LoadDeals event, Emitter<DealState> emit) async {
    emit(DealLoading());

    try {
      allDeals = await repository.getDeals();

      emit(DealLoaded(
        allDeals: allDeals,
        filteredDeals: allDeals,
      ));
    } catch (e) {
      emit(DealError("Failed to load deals"));
    }
  }

  void _onSearchDeals(
      SearchDeals event, Emitter<DealState> emit) {
    currentSearch = event.query;
    emit(DealLoaded(
      allDeals: allDeals,
      filteredDeals: _applyFilters(),
    ));
  }

  void _onFilterDeals(
      FilterDeals event, Emitter<DealState> emit) {
    currentRisk = event.risk ?? currentRisk;
    currentIndustry = event.industry ?? currentIndustry;
    currentMinRoi = event.minRoi ?? currentMinRoi;
    currentMaxRoi = event.maxRoi ?? currentMaxRoi;

    emit(DealLoaded(
      allDeals: allDeals,
      filteredDeals: _applyFilters(),
    ));
  }

  void _onClearFilters(
      ClearFilters event, Emitter<DealState> emit) {
    currentRisk = null;
    currentIndustry = null;
    currentMinRoi = null;
    currentMaxRoi = null;
    currentSearch = "";

    emit(DealLoaded(
      allDeals: allDeals,
      filteredDeals: allDeals,
    ));
  }

  List<Deal> _applyFilters() {
    return allDeals.where((deal) {
      final matchSearch = deal.companyName
          .toLowerCase()
          .contains(currentSearch.toLowerCase());

      final matchRisk =
          currentRisk == null || deal.risk == currentRisk;

      final matchIndustry =
          currentIndustry == null ||
              deal.industry == currentIndustry;

      final matchRoi =
          (currentMinRoi == null || deal.roi >= currentMinRoi!) &&
              (currentMaxRoi == null || deal.roi <= currentMaxRoi!);

      return matchSearch &&
          matchRisk &&
          matchIndustry &&
          matchRoi;
    }).toList();
  }
}