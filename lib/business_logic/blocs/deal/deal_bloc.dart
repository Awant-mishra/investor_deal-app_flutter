import 'package:flutter_bloc/flutter_bloc.dart';
import 'deal_event.dart';
import 'deal_state.dart';
import '../../../data/models/deal_model.dart';
import '../../../data/repositories/deal_repository.dart';

class DealBloc extends Bloc<DealEvent, DealState> {
  final DealRepository repository;

  List<Deal> allDeals = [];

  // 👉 Current filters (important for copyWith behavior)
  String? currentRisk;
  String? currentIndustry;
  double? currentMinRoi;
  double? currentMaxRoi;
  String currentSearch = "";

  DealBloc(this.repository) : super(DealLoading()) {
    on<LoadDeals>(_onLoadDeals);
    on<SearchDeals>(_onSearchDeals);
    on<FilterDeals>(_onFilterDeals);
  }

  // ================= LOAD =================
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

  // ================= SEARCH =================
  void _onSearchDeals(
      SearchDeals event, Emitter<DealState> emit) {
    currentSearch = event.query;

    final filtered = _applyAllFilters();

    emit(DealLoaded(
      allDeals: allDeals,
      filteredDeals: filtered,
    ));
  }

  // ================= FILTER =================
  void _onFilterDeals(
      FilterDeals event, Emitter<DealState> emit) {
    // 👉 copyWith-style update (only update what comes)
    currentRisk = event.risk ?? currentRisk;
    currentIndustry = event.industry ?? currentIndustry;
    currentMinRoi = event.minRoi ?? currentMinRoi;
    currentMaxRoi = event.maxRoi ?? currentMaxRoi;

    final filtered = _applyAllFilters();

    emit(DealLoaded(
      allDeals: allDeals,
      filteredDeals: filtered,
    ));
  }

  // ================= CORE FILTER FUNCTION =================
  List<Deal> _applyAllFilters() {
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

      return matchSearch && matchRisk && matchIndustry && matchRoi;
    }).toList();
  }

  // ================= OPTIONAL: CLEAR FILTER =================
  void clearFilters(Emitter<DealState> emit) {
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
}